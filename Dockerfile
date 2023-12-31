# Use the official Windows base image for containers
FROM mcr.microsoft.com/windows:10.0.17763.4499 as base

# Configure PowerShell as the default shell with specific preferences
SHELL ["powershell", "-command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# Set the working directory
WORKDIR C:/work_folder

# Copy required files into the container
RUN Invoke-WebRequest 'https://drive.google.com/uc?export=download&id=13CEy3smPFMKFPkWmMPzBDTJQZl1IMgL9&confirm=t' -OutFile cube_setup.exe
RUN Invoke-WebRequest 'https://drive.google.com/uc?export=download&id=1C6sX29ade5ZCsH-28z0evgDzhyLRTJnl&confirm=t' -OutFile connection_client_setup.exe
COPY powershell/set_env.ps1 set_env.ps1
COPY powershell/conn_client_logon_script.ps1 conn_client_logon_script.ps1

# List all files and directories within the workdir for debugging purposes
RUN Get-ChildItem -Recurse C:/work_folder

# Install CUBE silently
RUN Start-Process -FilePath 'C:\work_folder\cube_setup.exe' -ArgumentList '/VERYSILENT', '/SUPPRESSMSGBOXES', '/INSTALLGIS=NO', '/AUTHORIZEGIS=NO' -Wait

# Install CONNECTION Client silently
RUN Start-Process -FilePath 'C:\work_folder\connection_client_setup.exe' -ArgumentList '/s', 'NoStartPostInstall=1', 'InstallDesktopShortcut=0' -Wait

# Remove the installer files
RUN Remove-Item C:/work_folder/cube_setup.exe
RUN Remove-Item C:/work_folder/connection_client_setup.exe

# Configure and log into CONNECTION Client
RUN Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine
RUN .\set_env.ps1

# Copy a Voyager test script into the container
COPY test-scripts/test.S test.S

# Set the default command for the container
CMD [ "cmd" ]
