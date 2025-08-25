
ENV NEW_RELIC_LICENSE_KEY=""
ENV NEW_RELIC_APP_NAME="DockerNewRelicDemo"
# Use Windows Server Core base image
FROM mcr.microsoft.com/dotnet/aspnet:8.0-windowsservercore-ltsc2022 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443


# Download the New Relic .NET agent installer
RUN powershell.exe [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;\
 Invoke-WebRequest "https://download.newrelic.com/dot_net_agent/latest_release/NewRelicDotNetAgent_x64.msi"\
 -UseBasicParsing -OutFile "NewRelicDotNetAgent_x64.msi"

# Install the New Relic .NET agent
RUN powershell.exe Start-Process -Wait -FilePath msiexec -ArgumentList /i, "NewRelicDotNetAgent_x64.msi", /qn,\
 NR_LICENSE_KEY=NEW_RELIC_LICENSE_KEY

# Remove the New Relic .NET agent installer
RUN powershell.exe -c 'Remove-Item "NewRelicDotNetAgent_x64.msi"'

# Enable the agent
ENV CORECLR_ENABLE_PROFILING=1

FROM mcr.microsoft.com/dotnet/sdk:8.0-windowsservercore-ltsc2022 AS build
WORKDIR /src
COPY ["DockerNewRelicDemo.csproj", "./"]
RUN dotnet restore "./DockerNewRelicDemo.csproj"
COPY . .
RUN dotnet publish "DockerNewRelicDemo.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=build /app/publish .
EXPOSE 5000
ENTRYPOINT ["dotnet", "DockerNewRelicDemo.dll"]


