@echo off
REM --------------------------------------------------------------
REM - Script to start Service
REM --------------------------------------------------------------

SET _pack=%1
SET _archievefilename=%2
SET _dockercommand=%3
SET _msfname=%MSF_NAME%
SET _database=%DATABASE%
      
REM retriving archive file extension
SET _archievefileext=%_archievefilename:~-3%

if NOT "%_dockercommand%" == "down" (
 
   if "%_archievefileext%" == "war" (
      if exist %_pack%\WEB-INF\lib\*-entity-* del /f %_pack%\WEB-INF\lib\*-entity-*
      xcopy app\dbjars\%_msfname%-entity-%_database%.jar %_pack%\WEB-INF\lib\%_msfname%-entity-%_database%.jar* /d
      cd app\api
      jar -uvf %_archievefilename% WEB-INF/lib/%_msfname%-entity-%_database%%_timestamp%.jar
      cd ../../
      rmdir /s /q %_pack%\WEB-INF 	
   )   
   
   if "%_archievefileext%" == "jar" (
      xcopy %_pack%\%_archievefilename% %_pack%\repack\* /d 	  
      cd %_pack%\repack
      jar xf %_archievefilename%
      del %_archievefilename%
      if exist BOOT-INF\lib\*-entity-* del /f BOOT-INF\lib\*-entity-*
      xcopy ..\..\dbjars\%_msfname%-entity-%_database%.jar BOOT-INF\lib\%_msfname%-entity-%_database%.jar* /d	  
      jar -cfm0 ../%_archievefilename% META-INF\MANIFEST.MF .
      cd ..\..\..\ 
      rmdir /s /q %_pack%\repack
   )   
)