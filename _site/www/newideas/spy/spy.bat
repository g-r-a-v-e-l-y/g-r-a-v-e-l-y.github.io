ECHO OFF

cd\web\inetpub\wwwroot\spy

copy /y spy5.jpg spy6.jpg
copy /y spythumb5.jpg spythumb6.jpg

copy /y spy4.jpg spy5.jpg
copy /y spythumb4.jpg spythumb5.jpg

copy /y spy3.jpg spy4.jpg
copy /y spythumb3.jpg spythumb4.jpg

copy /y spy2.jpg spy3.jpg
copy /y spythumb2.jpg spythumb3.jpg

copy /y spy.jpg spy2.jpg
copy /y spythumb.jpg spythumb2.jpg

cd\web\inetpub\wwwroot

copy /y spy.jpg c:\web\inetpub\wwwroot\spy\spy.jpg
copy /y spy.jpg c:\web\inetpub\wwwroot\spy\spycopy.jpg

cd\web\inetpub\wwwroot\spy

C:\graphics\apps\Iview\i_view32.exe c:\web\inetpub\wwwroot\spy\spycopy.jpg /resize=(240,180)

move /y spycopy.jpg spythumb.jpg
