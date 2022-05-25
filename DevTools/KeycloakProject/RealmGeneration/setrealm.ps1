 $fileContents = get-content keycloak.properties

 $properties = @{}

 foreach($line in $fileContents)
 {
     $words = $line.Split('=',2)
     $properties.add($words[0].Trim(), $words[1].Trim())
 }

 # fetch access token 
 $body = @{username=$properties.KEYCLOAK_USER
      password=$properties.KEYCLOAK_SECRET
      grant_type='password'
      client_id='admin-cli'}
 $contentType = 'application/x-www-form-urlencoded' 
 $Url = $properties.KEYCLOAK_URL+'/auth/realms/'+$properties.KEYCLOAK_REALM+'/protocol/openid-connect/token'
 $response = Invoke-RestMethod -Method POST -ContentType $contentType -Body $body -Uri $Url 
 $token = $response.access_token
 
 # add new realm
 $Headers = @{'Authorization'= 'Bearer '+$token}
 $body = @([IO.File]::ReadAllText('realm.json'));
 $contentType = 'application/json'
 $Url = $properties.KEYCLOAK_URL+'/auth/admin/realms'
 Invoke-RestMethod -Method POST -Headers $Headers -ContentType $contentType -Body $body -Uri $Url  


