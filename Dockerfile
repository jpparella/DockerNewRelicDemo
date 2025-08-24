# Use Windows Server Core base image
FROM mcr.microsoft.com/dotnet/aspnet:8.0-windowsservercore-ltsc2022 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:8.0-windowsservercore-ltsc2022 AS build
WORKDIR /src
COPY ["DockerNewRelicDemo.csproj", "./"]
RUN dotnet restore "./DockerNewRelicDemo.csproj"
COPY . .
RUN dotnet publish "DockerNewRelicDemo.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "DockerNewRelicDemo.dll"]
