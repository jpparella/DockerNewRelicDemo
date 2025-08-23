# Build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY DockerNewRelicDemo.csproj .
RUN dotnet restore DockerNewRelicDemo.csproj
COPY . .
RUN dotnet publish DockerNewRelicDemo.csproj -c Release -o /out

# Runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /out .
EXPOSE 80
ENTRYPOINT ["dotnet", "DockerNewRelicDemo.dll"]
