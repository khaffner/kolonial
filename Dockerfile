FROM mcr.microsoft.com/powershell

ADD AutoShopper.ps1 /app/
ADD List.csv /app/

WORKDIR /app/

ENTRYPOINT [ "pwsh", "-File", "/app/AutoShopper.ps1" ]