package com.temenos.microservice.cucumber.utility.stepdefs;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;
/**
 * Scenario Bundles required for scenarios 
 * 
 * @author mohamedasarudeen
 */
public class ScenarioBundle implements Map<String, Object> {

    HashMap<String, Object> bundle = new HashMap<>();

    public String getString(Object key) {
        Object value = bundle.get(key);
        if (value == null) {
            return null;
        } else {
            return String.valueOf(value);
        }
    }

    public Integer getInteger(Object key) {
        Object value = bundle.get(key);
        if (value == null) {
            return null;
        } else {
            return Integer.valueOf(String.valueOf(value));
        }
    }

    @Override
    public int size() {
        return bundle.size();
    }

    @Override
    public boolean isEmpty() {
        return bundle.isEmpty();
    }

    @Override
    public boolean containsKey(Object key) {
        return bundle.containsKey(key);
    }

    @Override
    public boolean containsValue(Object value) {
        return bundle.containsValue(value);
    }

    @Override
    public Object get(Object key) {
        return bundle.get(key);
    }

    @Override
    public Object put(String key, Object value) {
        return bundle.put(key, value);
    }

    @Override
    public Object remove(Object key) {
        return bundle.remove(key);
    }

    @Override
    public void putAll(Map<? extends String, ? extends Object> m) {
        bundle.putAll(m);
    }

    @Override
    public void clear() {
        bundle.clear();
    }

    @Override
    public Set<String> keySet() {
        return bundle.keySet();
    }

    @Override
    public Collection<Object> values() {
        return bundle.values();
    }

    @Override
    public Set<java.util.Map.Entry<String, Object>> entrySet() {
        return bundle.entrySet();
    }

}
