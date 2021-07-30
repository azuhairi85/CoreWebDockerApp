#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["CoreWebDockerApp/CoreWebDockerApp.csproj", "CoreWebDockerApp/"]
RUN dotnet restore "CoreWebDockerApp/CoreWebDockerApp.csproj"
COPY . .
WORKDIR "/src/CoreWebDockerApp"
RUN dotnet build "CoreWebDockerApp.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "CoreWebDockerApp.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "CoreWebDockerApp.dll"]