@echo off

:: based on MANAGE CONNECTIONS FROM WINDOWS 10 OPERATING SYSTEM COMPONENTS TO MICROSOFT SERVICES as of September 16, 2019

:: ask for elevation passing args and preventing loop
set "args="%~f0" %*" & reg query HKU\S-1-5-19>nul 2>nul || if "%_%" neq "y" (
powershell -c "$Env:_='y';$ErrorActionPreference=0;start cmd -Arg \"/c call $Env:args\" -verb runas" & exit)

:: HKCU entries will also be propagated to new users:
reg load HKU\New "C:\Users\Default\NTUSER.DAT" >nul && set "HKU=1" || set "HKU="

REM TO DISABLE A POLICY, UNCOMMENT THE REG DELETE ENTRY BELOW IT

REM Telemetry - Security level is only supported on Education and Enterprise [best editions privacy-wise]
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /f /v AllowTelemetry /d 0 /t reg_dword
::reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /f /v AllowTelemetry

REM Automatic Root Certificates Update [delete recommended]
::reg add "HKLM\SOFTWARE\Policies\Microsoft\SystemCertificates\AuthRoot" /f /v DisableRootAutoUpdate /d 1 /t reg_dword
reg delete "HKLM\SOFTWARE\Policies\Microsoft\SystemCertificates\AuthRoot" /f /v DisableRootAutoUpdate

REM Cortana & Search
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /f /v AllowCortana /d 0 /t reg_dword
::reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /f /v AllowCortana

REM Search & Cortana to use location
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /f /v AllowSearchToUseLocation /d 0 /t reg_dword
::reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /f /v AllowSearchToUseLocation

REM Web Search
::reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /f /v DisableWebSearch /d 1 /t reg_dword
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /f /v DisableWebSearch

REM Search the web or display web results in Search
::reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /f /v ConnectedSearchUseWeb /d 0 /t reg_dword
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /f /v ConnectedSearchUseWeb

REM Outbound Cortana traffic
reg add "HKLM\SOFTWARE\Policies\Microsoft\WindowsFirewall\FirewallRules" /f /v {0DE40C8E-C126-4A27-9371-A27DAB1039F7} /d "v2.25|Action=Block|Active=TRUE|Dir=Out|Protocol=6|App=%windir%\SystemApps\Microsoft.Windows.Cortana_cw5n1h2txyewy\searchUI.exe|Name=Outbound Cortana traffic|"
::reg delete "HKLM\SOFTWARE\Policies\Microsoft\WindowsFirewall\FirewallRules" /f /v {0DE40C8E-C126-4A27-9371-A27DAB1039F7}

REM Set the time automatically [delete recommended]
::reg add "HKLM\SOFTWARE\Policies\Microsoft\W32time\TimeProviders\NtpClient" /f /v Enabled /d 0 /t reg_dword
reg delete "HKLM\SOFTWARE\Policies\Microsoft\W32time\TimeProviders\NtpClient" /f /v Enabled

REM Device metadata retrieval
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Device Metadata" /f /v PreventDeviceMetadataFromNetwork /d 1 /t reg_dword
::reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Device Metadata" /f /v PreventDeviceMetadataFromNetwork

REM Find My Device
::reg add "HKLM\SOFTWARE\Policies\Microsoft\FindMyDevice" /f /v AllowFindMyDevice /d 0 /t reg_dword
reg delete "HKLM\SOFTWARE\Policies\Microsoft\FindMyDevice" /f /v AllowFindMyDevice

REM Font streaming
::reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /f /v EnableFontProviders /d 0 /t reg_dword
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /f /v EnableFontProviders

REM Insider Preview builds - all such builds force Telemetry to FULL !!!
::reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds" /f /v AllowBuildPreview /d 0 /t reg_dword
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds" /f /v AllowBuildPreview

REM Internet Explorer

REM First run wizard
reg add "HKCU\SOFTWARE\Policies\Microsoft\Internet Explorer\Main" /f /v DisableFirstRunCustomize /d 1 /t reg_dword
::reg delete "HKCU\SOFTWARE\Policies\Microsoft\Internet Explorer\Main" /f /v DisableFirstRunCustomize

if defined HKU reg add "HKU\New\SOFTWARE\Policies\Microsoft\Internet Explorer\Main" /f /v DisableFirstRunCustomize /d 1 /t reg_dword
::if defined HKU reg delete "HKU\New\SOFTWARE\Policies\Microsoft\Internet Explorer\Main" /f /v DisableFirstRunCustomize

REM Online Tips
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /f /v AllowOnlineTips /d 0 /t reg_dword
::reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /f /v AllowOnlineTips

REM Browser Geolocation
reg add "HKLM\SOFTWARE\Policies\Microsoft\Internet Explorer\Geolocation" /f /v PolicyDisableGeolocation /d 1 /t reg_dword
::reg delete "HKLM\SOFTWARE\Policies\Microsoft\Internet Explorer\Geolocation" /f /v PolicyDisableGeolocation

REM SmartScreen filter [delete recommended]
::reg add "HKLM\SOFTWARE\Policies\Microsoft\Internet Explorer\PhishingFilter" /f /v EnabledV9 /d 0 /t reg_dword
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Internet Explorer\PhishingFilter" /f /v EnabledV9

REM Flip ahead with page prediction feature
reg add "HKLM\SOFTWARE\Policies\Microsoft\Internet Explorer\FlipAhead" /f /v Enabled /d 0 /t reg_dword
::reg delete "HKLM\SOFTWARE\Policies\Microsoft\Internet Explorer\FlipAhead" /f /v Enabled

REM Background synchronization for feeds and Web Slices
reg add "HKLM\SOFTWARE\Policies\Microsoft\Internet Explorer\Feeds" /f /v BackgroundSyncStatus /d 0 /t reg_dword
::reg delete "HKLM\SOFTWARE\Policies\Microsoft\Internet Explorer\Feeds" /f /v BackgroundSyncStatus

REM ActiveX control blocking [delete recommended]
::reg add "HKCU\Software\Microsoft\Internet Explorer\VersionManager" /f /v DownloadVersionList /d 0 /t reg_dword
reg delete "HKCU\Software\Microsoft\Internet Explorer\VersionManager" /f /v DownloadVersionList

::if defined HKU reg add "HKU\New\Software\Microsoft\Internet Explorer\VersionManager" /f /v DownloadVersionList /d 0 /t reg_dword
if defined HKU reg delete "HKU\New\Software\Microsoft\Internet Explorer\VersionManager" /f /v DownloadVersionList

REM License Manager [3 recommended]
::reg add "HKLM\System\CurrentControlSet\Services\LicenseManager" /f /v Start /d 4 /t reg_dword
reg add "HKLM\System\CurrentControlSet\Services\LicenseManager" /f /v Start /d 3 /t reg_dword

REM Live Tiles
::reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications" /f /v NoCloudApplicationNotification /d 1 /t reg_dword
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications" /f /v NoCloudApplicationNotification

REM Mail synchronization [delete recommended]
::reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Mail" /f /v ManualLaunchAllowed /d 0 /t reg_dword
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Mail" /f /v ManualLaunchAllowed

REM Microsoft Account Sign-In Assistant [3 recommended]
::reg add "HKLM\System\CurrentControlSet\Services\wlidsvc" /f /v Start /d 4 /t reg_dword
reg add "HKLM\System\CurrentControlSet\Services\wlidsvc" /f /v Start /d 3 /t reg_dword

REM Microsoft Edge

REM First run ad
reg add "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Main" /f /v PreventFirstRunPage /d 1 /t reg_dword
::reg delete "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Main" /f /v PreventFirstRunPage

REM Live Tile telemetry
reg add "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Main" /f /v PreventLiveTileDataCollection /d 1 /t reg_dword
::reg delete "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Main" /f /v PreventLiveTileDataCollection

REM Adobe Flash
::reg add "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Addons" /f /v FlashPlayerEnabled /d 0 /t reg_dword
reg delete "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Addons" /f /v FlashPlayerEnabled

REM Windows Defender SmartScreen Filter [delete recommended]
::reg add "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\PhishingFilter" /f /v EnabledV9 /d 0 /t reg_dword
reg delete "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\PhishingFilter" /f /v EnabledV9

REM Pre-launch at Windows startup, when the system is idle, and each time Microsoft Edge is closed
reg add "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Main" /f /v AllowPrelaunch /d 0 /t reg_dword
::reg delete "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Main" /f /v AllowPrelaunch

REM Load the Start and New Tab page at Windows startup and each time Microsoft Edge is closed
reg add "HKCU\SOFTWARE\Policies\Microsoft\MicrosoftEdge\TabPreloader" /f /v AllowTabPreloading /d 0 /t reg_dword
::reg delete "HKCU\SOFTWARE\Policies\Microsoft\MicrosoftEdge\TabPreloader" /f /v AllowTabPreloading

if defined HKU reg add "HKU\New\SOFTWARE\Policies\Microsoft\MicrosoftEdge\TabPreloader" /f /v AllowTabPreloading /d 0 /t reg_dword
::if defined HKU reg delete "HKU\New\SOFTWARE\Policies\Microsoft\MicrosoftEdge\TabPreloader" /f /v AllowTabPreloading

REM Network Connection Status Indicator
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\NetworkConnectivityStatusIndicator" /f /v NoActiveProbe /d 1 /t reg_dword
::reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\NetworkConnectivityStatusIndicator" /f /v NoActiveProbe

REM Offline Maps
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Maps" /f /v AutoDownloadAndUpdateMapData /d 0 /t reg_dword
::reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Maps" /f /v AutoDownloadAndUpdateMapData

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Maps" /f /v AllowUntriggeredNetworkTrafficOnSettingsPage /d 0 /t reg_dword
::reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Maps" /f /v AllowUntriggeredNetworkTrafficOnSettingsPage

REM OneDrive
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /f /v DisableFileSyncNGSC /d 1 /t reg_dword
::reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /f /v DisableFileSyncNGSC

reg add "HKLM\SOFTWARE\Microsoft\OneDrive" /f /v PreventNetworkTrafficPreUserSignIn /d 1 /t reg_dword
::reg delete "HKLM\SOFTWARE\Microsoft\OneDrive" /f /v PreventNetworkTrafficPreUserSignIn

REM Settings -> Privacy -> General

REM Let apps use advertising ID to make ads more interesting to you based on your app usage
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /f /v Enabled /d 0 /t reg_dword
::reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /f /v Enabled

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" /f /v DisabledByGroupPolicy /d 1 /t reg_dword
::reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" /f /v DisabledByGroupPolicy

REM Let websites provide locally relevant content by accessing my language list
reg add "HKCU\Control Panel\International\User Profile" /f /v HttpAcceptLanguageOptOut /d 1 /t reg_dword
::reg delete "HKCU\Control Panel\International\User Profile" /f /v HttpAcceptLanguageOptOut

if defined HKU reg add "HKU\New\Control Panel\International\User Profile" /f /v HttpAcceptLanguageOptOut /d 1 /t reg_dword
::if defined HKU reg delete "HKU\New\Control Panel\International\User Profile" /f /v HttpAcceptLanguageOptOut

REM Let Windows track app launches to improve Start and search results
::reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v Start_TrackProgs /d 0 /t reg_dword
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v Start_TrackProgs

::if defined HKU reg add "HKU\New\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v Start_TrackProgs /d 0 /t reg_dword
if defined HKU reg delete "HKU\New\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v Start_TrackProgs

REM SmartScreen Filter to check web content (URLs) that Microsoft Store apps use [delete recommended]
::reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" /f /v EnableWebContentEvaluation /d 0 /t reg_dword
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" /f /v EnableWebContentEvaluation

::if defined HKU reg add "HKU\New\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" /f /v EnableWebContentEvaluation /d 0 /t reg_dword
if defined HKU reg delete "HKU\New\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" /f /v EnableWebContentEvaluation

REM Let apps on my other devices open apps and continue experiences on this device
::reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /f /v EnableCdp /d 0 /t reg_dword
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /f /v EnableCdp

REM Settings -> Privacy -> Location

REM Location for this device
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v LetAppsAccessLocation /d 2 /t reg_dword
::reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v LetAppsAccessLocation

REM Disable Location
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /f /v DisableLocation /d 1 /t reg_dword
::reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /f /v DisableLocation

REM Settings -> Privacy -> Camera [delete recommended]
::reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v LetAppsAccessCamera /d 2 /t reg_dword
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v LetAppsAccessCamera

REM Settings -> Privacy -> Microphone [delete recommended]
::reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v LetAppsAccessMicrophone /d 2 /t reg_dword
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v LetAppsAccessMicrophone

REM Settings -> Privacy -> Notifications

REM Let apps access my notifications [delete recommended]
::reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v LetAppsAccessNotifications /d 2 /t reg_dword
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v LetAppsAccessNotifications

REM Settings -> Privacy -> Speech
reg add "HKCU\Software\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy" /f /v HasAccepted /d 0 /t reg_dword
::reg delete "HKCU\Software\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy" /f /v HasAccepted

if defined HKU reg add "HKU\New\Software\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy" /f /v HasAccepted /d 0 /t reg_dword
::if defined HKU reg delete "HKU\New\Software\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy" /f /v HasAccepted

reg add "HKLM\SOFTWARE\Policies\Microsoft\Speech" /f /v AllowSpeechModelUpdate /d 0 /t reg_dword
::reg delete "HKLM\SOFTWARE\Policies\Microsoft\Speech" /f /v AllowSpeechModelUpdate

REM Settings -> Privacy -> Account info [delete recommended]
::reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v LetAppsAccessAccountInfo /d 2 /t reg_dword
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v LetAppsAccessAccountInfo

REM Settings -> Privacy -> Contacts [delete recommended]
::reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v LetAppsAccessContacts /d 2 /t reg_dword
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v LetAppsAccessContacts

REM Settings -> Privacy -> Calendar [delete recommended]
::reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v LetAppsAccessCalendar /d 2 /t reg_dword
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v LetAppsAccessCalendar

REM Settings -> Privacy -> Call history [delete recommended]
::reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v LetAppsAccessCallHistory /d 2 /t reg_dword
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v LetAppsAccessCallHistory

REM Settings -> Privacy -> Email [delete recommended]
::reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v LetAppsAccessEmail /d 2 /t reg_dword
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v LetAppsAccessEmail

REM Settings -> Privacy -> Messaging [delete recommended]
::reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v LetAppsAccessMessaging /d 2 /t reg_dword
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v LetAppsAccessMessaging

::reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Messaging" /f /v AllowMessageSync /d 0 /t reg_dword
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Messaging" /f /v AllowMessageSync

REM Settings -> Privacy -> Phone calls [delete recommended]
::reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v LetAppsAccessPhone /d 2 /t reg_dword
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v LetAppsAccessPhone

REM Settings -> Privacy -> Radios [delete recommended]
::reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v LetAppsAccessRadios /d 2 /t reg_dword
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v LetAppsAccessRadios

REM Settings -> Privacy -> Other devices [delete recommended]
::reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v LetAppsSyncWithDevices /d 2 /t reg_dword
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v LetAppsSyncWithDevices

::reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v LetAppsAccessTrustedDevices /d 2 /t reg_dword
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v LetAppsAccessTrustedDevices

REM Settings -> Privacy -> Feedback and Diagnostics

REM Ask for feedback
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /f /v DoNotShowFeedbackNotifications /d 1 /t reg_dword
::reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /f /v DoNotShowFeedbackNotifications

reg add "HKCU\Software\Microsoft\Siuf\Rules" /f /v PeriodInNanoSeconds /d 0 /t reg_dword
::reg delete "HKCU\Software\Microsoft\Siuf\Rules" /f /v PeriodInNanoSeconds

if defined HKU reg add "HKU\New\Software\Microsoft\Siuf\Rules" /f /v PeriodInNanoSeconds /d 0 /t reg_dword
::if defined HKU reg delete "HKU\New\Software\Microsoft\Siuf\Rules" /f /v PeriodInNanoSeconds

reg add "HKCU\Software\Microsoft\Siuf\Rules" /f /v NumberOfSIUFInPeriod /d 0 /t reg_dword
::reg delete "HKCU\Software\Microsoft\Siuf\Rules" /f /v NumberOfSIUFInPeriod

if defined HKU reg add "HKU\New\Software\Microsoft\Siuf\Rules" /f /v NumberOfSIUFInPeriod /d 0 /t reg_dword
::if defined HKU reg delete "HKU\New\Software\Microsoft\Siuf\Rules" /f /v NumberOfSIUFInPeriod

REM Tailored experiences with relevant tips and recommendations by using your diagnostics data
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /f /v DisableWindowsConsumerFeatures /d 1 /t reg_dword
::reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /f /v DisableWindowsConsumerFeatures

reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /f /v DisableTailoredExperiencesWithDiagnosticData /d 1 /t reg_dword
::reg delete "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /f /v DisableTailoredExperiencesWithDiagnosticData

if defined HKU reg add "HKU\New\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /f /v DisableTailoredExperiencesWithDiagnosticData /d 1 /t reg_dword
::if defined HKU reg delete "HKU\New\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /f /v DisableTailoredExperiencesWithDiagnosticData

REM Background apps [delete recommended]
::reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v LetAppsRunInBackground /d 2 /t reg_dword
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v LetAppsRunInBackground

REM Motion [delete recommended]
::reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v LetAppsAccessMotion /d 2 /t reg_dword
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v LetAppsAccessMotion

REM Tasks [delete recommended]
::reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v LetAppsAccessTasks /d 2 /t reg_dword
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v LetAppsAccessTasks

REM App Diagnostics [delete recommended]
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v LetAppsGetDiagnosticInfo /d 2 /t reg_dword
::reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v LetAppsGetDiagnosticInfo

REM Inking and Typing
reg add "HKLM\SOFTWARE\Policies\Microsoft\InputPersonalization" /f /v RestrictImplicitTextCollection /d 1 /t reg_dword
::reg delete "HKLM\SOFTWARE\Policies\Microsoft\InputPersonalization" /f /v RestrictImplicitTextCollection

REM Activity History
::reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /f /v EnableActivityFeed /d 2 /t reg_dword
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /f /v EnableActivityFeed

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /f /v PublishUserActivities /d 2 /t reg_dword
::reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /f /v PublishUserActivities

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /f /v UploadUserActivities /d 2 /t reg_dword
::reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /f /v UploadUserActivities

REM Voice Activation
::reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v LetAppsActivateWithVoice /d 2 /t reg_dword
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v LetAppsActivateWithVoice

::reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v LetAppsActivateWithVoiceAboveLock /d 2 /t reg_dword
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /f /v LetAppsActivateWithVoiceAboveLock

REM Software Protection Platform [delete recommended]
::reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Software Protection Platform" /f /v NoGenTicket /d 1 /t reg_dword
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Software Protection Platform" /f /v NoGenTicket

REM Storage Health
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\StorageHealth" /f /v AllowDiskHealthModelUpdates /d 0 /t reg_dword
::reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\StorageHealth" /f /v AllowDiskHealthModelUpdates

REM Sync your settings
::reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /f /v DisableSettingSync /d 2 /t reg_dword
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /f /v DisableSettingSync

::reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /f /v DisableSettingSyncUserOverride /d 1 /t reg_dword
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /f /v DisableSettingSyncUserOverride

::reg add "HKCU\SOFTWARE\Microsoft\Messaging" /f /v CloudServiceSyncEnabled /d 0 /t reg_dword
reg delete "HKCU\SOFTWARE\Microsoft\Messaging" /f /v CloudServiceSyncEnabled

::if defined HKU reg add "HKU\New\SOFTWARE\Microsoft\Messaging" /f /v CloudServiceSyncEnabled /d 0 /t reg_dword
if defined HKU reg delete "HKU\New\SOFTWARE\Microsoft\Messaging" /f /v CloudServiceSyncEnabled

REM Teredo [delete recommended]
::reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\TCPIP\v6Transition" /f /v Teredo_State /d "Disabled"
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\TCPIP\v6Transition" /f /v Teredo_State

REM Wi-Fi Sense
reg add "HKLM\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config" /f /v AutoConnectAllowedOEM /d 0 /t reg_dword
::reg delete "HKLM\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config" /f /v AutoConnectAllowedOEM

REM Windows Defender
::reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /f /v SubmitSamplesConsent /d 2 /t reg_dword
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /f /v SubmitSamplesConsent

::reg add "HKLM\SOFTWARE\Policies\Microsoft\MRT" /f /v DontReportInfectionInformation /d 1 /t reg_dword
reg delete "HKLM\SOFTWARE\Policies\Microsoft\MRT" /f /v DontReportInfectionInformation

::reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Reporting" /f /v DisableEnhancedNotifications /d 1 /t reg_dword
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Reporting" /f /v DisableEnhancedNotifications

REM Could trade a bit of privacy for more security against unclassified software by enabling SpyNet advanced membership
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /f /v SpyNetReporting /d 2 /t reg_dword
::reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /f /v SpyNetReporting

REM Windows Defender SmartScreen
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /f /v EnableSmartScreen /d 0 /t reg_dword
::reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /f /v EnableSmartScreen

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\SmartScreen" /f /v ConfigureAppInstallControlEnabled /d 1 /t reg_dword
::reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\SmartScreen" /f /v ConfigureAppInstallControlEnabled

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\SmartScreen" /f /v ConfigureAppInstallControl /d "Anywhere"
::reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\SmartScreen" /f /v ConfigureAppInstallControl

REM Windows Spotlight
::reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /f /v DisableWindowsSpotlightFeatures /d 1 /t reg_dword
reg delete "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /f /v DisableWindowsSpotlightFeatures

::if defined HKU reg add "HKU\New\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /f /v DisableWindowsSpotlightFeatures /d 1 /t reg_dword
if defined HKU reg delete "HKU\New\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /f /v DisableWindowsSpotlightFeatures

::reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" /f /v NoLockScreen /d 1 /t reg_dword
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" /f /v NoLockScreen

REM - Alternatively can set static Lock Screen
::reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" /f /v LockScreenImage /d "%SystemRoot%\web\screen\lockscreen.jpg"
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" /f /v LockScreenImage

::reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" /f /v LockScreenOverlaysDisabled /d 1 /t reg_dword
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" /f /v LockScreenOverlaysDisabled

REM Windows Tips
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /f /v DisableSoftLanding /d 1 /t reg_dword
::reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /f /v DisableSoftLanding

REM Microsoft Store bloat
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /f /v DisableWindowsConsumerFeatures /d 1 /t reg_dword
::reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /f /v DisableWindowsConsumerFeatures

REM Microsoft Store AutoDownload
reg add "HKLM\SOFTWARE\Policies\Microsoft\WindowsStore" /f /v AutoDownload /d 2 /t reg_dword
::reg delete "HKLM\SOFTWARE\Policies\Microsoft\WindowsStore" /f /v AutoDownload

REM Apps for websites [delete recommended]
::reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /f /v EnableAppUriHandlers /d 0 /t reg_dword
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /f /v EnableAppUriHandlers

REM Windows Update Delivery OptimizationTailoredExperiencesWithDiagnosticDataEnabled
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /f /v DODownloadMode /d 100 /t reg_dword
::reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /f /v DODownloadMode

REM Windows Update AutoDownload [delete recommended]
::reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\WindowsStore\WindowsUpdate" /f /v AutoDownload /d 5 /t reg_dword
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\WindowsStore\WindowsUpdate" /f /v AutoDownload

REM Bonus tweaks

REM Delete remnants of Diagtrack & Cortana

reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "{60E6D465-398E-4850-BE86-7EF7620A2377}" /t REG_SZ /d "v2.24|Action=Block|Active=TRUE|Dir=Out|App=C:\windows\system32\svchost.exe|Svc=DiagTrack|Name=Windows Telemetry|" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "{2765E0F4-2918-4A46-B9C9-43CDD8FCBA2B}" /t REG_SZ /d "v2.24|Action=Block|Active=TRUE|Dir=Out|App=C:\windows\systemapps\microsoft.windows.cortana_cw5n1h2txyewy\searchui.exe|Name=Search & Cortana|AppPkgId=S-1-15-2-1861897761-1695161497-2927542615-642690995-327840285-2659745135-2630312742|" /f

REM Additional Privacy tweaks

reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\OOBE" /v "DisablePrivacyExperience" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OOBE" /v "DisablePrivacyExperience" /t REG_DWORD /d "1" /f
reg delete "HKU\.DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" /v "Value" /f
reg add "HKU\.DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" /v "Value" /t REG_SZ /d "Deny" /f
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" /v "Value" /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" /v "Value" /t REG_SZ /d "Deny" /f
reg delete "HKLM\SOFTWARE\Microsoft\Settings\FindMyDevice" /v "LocationSyncEnabled" /f
reg add "HKLM\SOFTWARE\Microsoft\Settings\FindMyDevice" /v "LocationSyncEnabled" /t REG_DWORD /d "0" /f
reg delete "HKU\.DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack" /v "ShowedToastAtLevel" /f
reg add "HKU\.DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack" /v "ShowedToastAtLevel" /t REG_DWORD /d "1" /f
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack" /v "ShowedToastAtLevel" /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack" /v "ShowedToastAtLevel" /t REG_DWORD /d "1" /f
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "MaxTelemetryAllowed" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "MaxTelemetryAllowed" /t REG_DWORD /d "1" /f
reg delete "HKU\.DEFAULT\SOFTWARE\Microsoft\Input\TIPC" /v "Enabled" /f
reg add "HKU\.DEFAULT\SOFTWARE\Microsoft\Input\TIPC" /v "Enabled" /t REG_DWORD /d "0" /f
reg delete "HKCU\SOFTWARE\Microsoft\Input\TIPC" /v "Enabled" /f
reg add "HKCU\SOFTWARE\Microsoft\Input\TIPC" /v "Enabled" /t REG_DWORD /d "0" /f
reg delete "HKU\.DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy" /v "TailoredExperiencesWithDiagnosticDataEnabled" /f
reg add "HKU\.DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy" /v "TailoredExperiencesWithDiagnosticDataEnabled" /t REG_DWORD /d "0" /f
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy" /v "TailoredExperiencesWithDiagnosticDataEnabled" /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy" /v "TailoredExperiencesWithDiagnosticDataEnabled" /t REG_DWORD /d "0" /f

:: HKCU entries will also be propagated to new users
reg unload HKU\New >nul

echo Privacy policies setup finished!