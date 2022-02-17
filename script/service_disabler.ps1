# Description: This script disables unwanted Windows services. If you do not want to disable certain services comment out the corresponding lines below.

$services = @(
    "diagnosticshub.standardcollector.service"     # Microsoft (R) Diagnostics Hub Standard Collector Service
    "DiagTrack"                                    # Diagnostics Tracking Service
    "dmwappushservice"                             # WAP Push Message Routing Service (see known issues)
    "lfsvc"                                        # Geolocation Service
    "MapsBroker"                                   # Downloaded Maps Manager
    "NetTcpPortSharing"                            # Net.Tcp Port Sharing Service
    "RemoteAccess"                                 # Routing and Remote Access
    "RemoteRegistry"                               # Remote Registry
    "SharedAccess"                                 # Internet Connection Sharing (ICS)
    "TrkWks"                                       # Distributed Link Tracking Client
    "WbioSrvc"                                     # Windows Biometric Service (required for Fingerprint reader / facial detection)
    # "WlanSvc"                                    # WLAN AutoConfig
    "WMPNetworkSvc"                                # Windows Media Player Network Sharing Service
    # "wscsvc"                                     # Windows Security Center Service
    "WSearch"                                      # Windows Search
    "XblAuthManager"                               # Xbox Live Auth Manager
    "XblGameSave"                                  # Xbox Live Game Save Service
    "XboxNetApiSvc"                                # Xbox Live Networking Service
    "XboxGipSvc"                                   # Disables Xbox Accessory Management Service
    # "ndu"                                        # Windows Network Data Usage Monitor
    "WerSvc"                                       # Disables Windows Error Reporting
    # "Spooler"                                    # Disables Printer
    "Fax"                                          # Disables Fax
    "fhsvc"                                        # Disables Fax History
    "gupdate"                                      # Disables Google Update
    "gupdatem"                                     # Disables another Google Update
    "stisvc"                                       # Disables Windows Image Acquisition (WIA)
    "AJRouter"                                     # Disables (needed for AllJoyn Router Service)
    "MSDTC"                                        # Disables Distributed Transaction Coordinator
    "WpcMonSvc"                                    # Disables Parental Controls
    "PhoneSvc"                                     # Disables Phone Service (Manages the telephony state on the device)
    "PrintNotify"                                  # Disables Windows Printer notifications and extentions
    "PcaSvc"                                       # Disables Program Compatibility Assistant Service
    "WPDBusEnum"                                   # Disables Portable Device Enumerator Service
    # "LicenseManager"                             # Disables LicenseManager (Windows Store may not work properly)
    # "seclogon"                                   # Disables Secondary Logon (Disables other credentials only password will work)
    "SysMain"                                      # Disables SysMain
    "lmhosts"                                      # Disables TCP/IP NetBIOS Helper
    "wisvc"                                        # Disables Windows Insider program (Windows Insider will not work)
    # "FontCache"                                  # Disables Windows Font Cache (Causes Winlogon struggles)
    "RetailDemo"                                   # Disables RetailDemo which is often used when showing your device
    "ALG"                                          # Disables Application Layer Gateway Service (Provides support for 3rd party protocol plug-ins for Internet Connection Sharing)
    # "BFE"                                        # Disables Base Filtering Engine (BFE) (is a service that manages Firewall and Internet Protocol security)
    # "BrokerInfrastructure"                       # Disables Windows Infrastructure Service that controls which background tasks can run on the system
    "SCardSvr"                                     # Disables Windows Smart Card
    # "EntAppSvc"                                  # Disables Enterprise Application Management
    # "BthAvctpSvc"                                # Disables AVCTP service (if you use Bluetooth Audio Device or Wireless Headphones, then don't disable this)
    # "FrameServer"                                # Disables Windows Camera Frame Server (This allows multiple clients to access video frames from camera devices)
    "Browser"                                      # Disables Computer Browser Service
    "BDESVC"                                       # Disables Bitlocker
    "iphlpsvc"                                     # Disables IPv6 but most websites don't use IPv6 they use IPv4
    "edgeupdate"                                   # Disables Edge Update service
    "edgeupdatem"                                  # Disables another one of Edge Update service
    "MicrosoftEdgeElevationService"                # Disables another Edge service
    "SEMgrSvc"                                     # Disables Payments and NFC/SE Manager (Manages payments and Near Field Communication (NFC) based secure elements)
    # "PNRPsvc"                                    # Disables Peer Name Resolution Protocol (Some peer-to-peer and collaborative applications, such as Remote Assistance, may not function. Discord will still work)
    # "p2psvc"                                     # Disables Peer Name Resolution Protocol (Enables multi-party communication using Peer-to-Peer Grouping. If disabled, some applications, such as HomeGroup, may not function. Discord will still work)
    # "p2pimsvc"                                   # Disables Peer Networking Identity Manager (Peer-to-Peer Grouping services may not function, and some applications, such as HomeGroup and Remote Assistance, may not function correctly. Discord will still work)
    "PerfHost"                                     # Disables Remote users and 64-bit processes to query performance
    "BcastDVRUserService_48486de"                  # Disables GameDVR and Broadcast is used for Game Recordings and Live Broadcasts
    "CaptureService_48486de"                       # Disables Optional screen capture functionality for applications that call the Windows.Graphics.Capture API
    # "cbdhsvc_48486de"                            # Disables cbdhsvc_48486de (clipboard service it disables)
    # "BluetoothUserService_48486de"               # Disables BluetoothUserService_48486de (The Bluetooth user service supports proper functionality of Bluetooth features relevant to each user session)
    # "WpnService"                                 # Disables WpnService (Push Notifications may not work)
    # "StorSvc"                                    # Disables StorSvc (USB external hard drive will not be recognised by Windows)
    "RtkBtManServ"                                 # Disables Realtek Bluetooth Device Manager Service
    # "QWAVE"                                      # Disables Quality Windows Audio Video Experience (Audio and Video might sound worse)

    # HP services
    "HPAppHelperCap"
    "HPDiagsCap"
    "HPNetworkCap"
    "HPSysInfoCap"
    "HPTouchpointAnalyticsService"

    # Hyper-V services
    "HvHost"                          
    "vmickvpexchange"
    "vmicguestinterface"
    "vmicheartbeat"
    "vmicrdv"
    "vmicshutdown"
    "vmictimesync" 
    "vmicvmsession"

    # Services which cannot be disabled
    # "WdNisSvc"
)

foreach ($service in $services) {
    # -ErrorAction SilentlyContinue is so it doesn't write an error to stdout if a service doesn't exist

    Write-Host "Setting $service StartupType to disabled"
    Get-Service -Name $service -ErrorAction SilentlyContinue | Set-Service -StartupType Disabled

    $running = Get-Service -Name $service -ErrorAction SilentlyContinue | Where-Object {$_.Status -eq 'Running'}
    if ($running) { 
        Write-Host "Stopping $service"
        Stop-Service -Name $service
    }
}