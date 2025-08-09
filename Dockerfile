# Use the official ASP.NET Core runtime as base image
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

# Use the SDK image to build the application
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["FileServices.Api/FileServices.Api.csproj", "FileServices.Api/"]
RUN dotnet restore "FileServices.Api/FileServices.Api.csproj"
COPY . .
WORKDIR "/src/FileServices.Api"
RUN dotnet build "FileServices.Api.csproj" -c Release -o /app/build

# Publish the application
FROM build AS publish
RUN dotnet publish "FileServices.Api.csproj" -c Release -o /app/publish

# Create the final runtime image
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .

# Create uploads directory
RUN mkdir -p /app/uploads

# Set environment variables
ENV ASPNETCORE_ENVIRONMENT=Production
ENV ASPNETCORE_URLS=http://+:80

ENTRYPOINT ["dotnet", "FileServices.Api.dll"]
