package com.temenos.microservice.cucumber.t24datastepdefinitions;

/*
 * #%L
 * useragent-generic-java
 * %%
 * Copyright (C) 2012 - 2017 Temenos Holdings N.V.
 * %%
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 * #L%
 */

import static com.temenos.useragent.generic.mediatype.PropertyNameUtil.extractIndex;
import static com.temenos.useragent.generic.mediatype.PropertyNameUtil.extractPropertyName;
import static com.temenos.useragent.generic.mediatype.PropertyNameUtil.isPropertyNameWithIndex;
import static java.text.MessageFormat.format;

import java.util.List;
import java.util.Optional;
import java.util.function.BiConsumer;

import org.json.JSONArray;
import org.json.JSONObject;

/**
 * Utility for JSON media-type
 *
 * @author mohamedasarudeen
 *
 */
public final class JsonUtil {

    private static BiConsumer<String, String> CHECK_VALID_PATH_PART = (String pathPart, String propertyPath) -> {
        if (!isPropertyNameWithIndex(pathPart)) {
            throw new IllegalArgumentException(
                    format("Invalid part {0} in fully qualified property name {1}", pathPart, propertyPath));
        }
    };

    private static BiConsumer<Integer, String> THROW_INVALID_PATH_EXCEPTION = (Integer index, String propertyPath) -> {
        throw new IllegalArgumentException(
                format("Unable to resolve index [{0}] for property path \"{1}\"", index, propertyPath));
    };

    private JsonUtil() {
    }

    /**
     * Flattens the fully qualified property name parts into an array.
     * 
     * <p>
     * For example, fully qualified property name <i>foo(0)/bar(1)/blah</i>
     * would be flattened into an array with <i>3</i> elements as <i>foo(0),
     * bar(1)</i> and <i>blah</i>.
     * </p>
     * 
     * @param fqPropertyName
     * @return array of property name parts 
     */
    public static String[] flattenPropertyName(String fqPropertyName) {
        if (fqPropertyName == null || fqPropertyName.isEmpty()) {
            throw new IllegalArgumentException("Invalid property name '" + fqPropertyName + "'");
        }
        return fqPropertyName.split("/");
    }

    public static Optional<JSONObject> navigateJsonObjectforPropertyPath(Optional<JSONObject> jsonResponse,
            List<String> pathParts, String fqPropertyName, boolean createChild) {
        if (pathParts.isEmpty() || !jsonResponse.isPresent()) {
            return jsonResponse;
        } else {
            String pathPart = pathParts.get(0);
            CHECK_VALID_PATH_PART.accept(pathPart, fqPropertyName);
            Optional<JSONObject> childObject = navigateChild(jsonResponse, extractPropertyName(pathPart),
                    extractIndex(pathPart), createChild);
            return navigateJsonObjectforPropertyPath(childObject, pathParts.subList(1, pathParts.size()),
                    fqPropertyName, createChild);
        }
    }

    public static Optional<JSONObject> navigateChild(Optional<JSONObject> parent, String propertyName, int index,
            boolean createChild) {
        if (parent.isPresent()) {
            // Check and get JSON object
            JSONObject parentJsonObj = parent.get();
            Optional<JSONObject> jsonObj = Optional.ofNullable(parentJsonObj.optJSONObject(propertyName));
            checkValidJsonIndex(jsonObj, index, createChild, propertyName);
            if (jsonObj.isPresent() && index == 0) {
                return jsonObj;
            }

            // Check and get JSON array -> JSON Object
            Optional<JSONArray> jsonArray = Optional.ofNullable(parentJsonObj.optJSONArray(propertyName));
            checkValidJsonIndex(jsonArray, index, createChild, propertyName);
            if (jsonArray.isPresent() && !createChild) {
                return Optional.ofNullable(jsonArray.get().optJSONObject(index));
            }

            // invalid path/object
            if (createChild && index != 0 && !jsonArray.isPresent() && !jsonObj.isPresent()) {
                THROW_INVALID_PATH_EXCEPTION.accept(index, propertyName);
            }

            // add to existing JSON array
            if (createChild && jsonArray.isPresent() && index == jsonArray.get().length()) {
                JSONObject newObject = new JSONObject();
                jsonArray.get().put(index, newObject);
                return Optional.of(newObject);
            }

            // get from existing JSON array
            if (createChild && jsonArray.isPresent() && index < jsonArray.get().length()) {
                return Optional.of((JSONObject) jsonArray.get().get(index));
            }

            // add new JSON item and update parent to JSON array
            if (createChild && jsonObj.isPresent() && index == 1) {
                JSONObject newObject = new JSONObject();
                JSONArray newArray = new JSONArray();
                newArray.put(jsonObj.get());
                newArray.put(newObject);
                parent.get().put(propertyName, newArray);
                return Optional.of(newObject);
            }

            if (createChild) {
                final JSONObject newObject = new JSONObject();
                final JSONArray newArray = new JSONArray();
                newArray.put(newObject);                
                parentJsonObj.put(propertyName, newArray);
                
                //override or warnings accept passing through headers
                
                if(propertyName.equalsIgnoreCase("override") || propertyName.equalsIgnoreCase("warnings")){
                    parentJsonObj.put(propertyName, newObject) ;
                }
                
                return Optional.of(newObject);
            }

            Optional.empty();
        }
        return parent;

    }

    public static void checkValidJsonIndex(@SuppressWarnings("rawtypes") Optional optional, int index,
            boolean createChild, String propertyName) {
        if (optional.isPresent() && optional.get() instanceof JSONObject) {
            // While creating child, check if the index is not greater than 1
            if (createChild && index > 1) {
                THROW_INVALID_PATH_EXCEPTION.accept(index, propertyName);
            }
        }

        if (optional.isPresent() && optional.get() instanceof JSONArray) {
            // While creating child, check if the index is not greater than the
            // array length by 1
            JSONArray jsonArray = (JSONArray) optional.get();
            if (createChild && index > jsonArray.length()) {
                THROW_INVALID_PATH_EXCEPTION.accept(index, propertyName);
            }
        }
    }
}
