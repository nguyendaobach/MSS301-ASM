# Deploy to Azure Container Instances
# Yêu cầu: Azure CLI đã cài đặt và đã login (az login)

# Set variables
$RESOURCE_GROUP="microservices-rg"
$LOCATION="southeastasia"

# Create resource group
az group create --name $RESOURCE_GROUP --location $LOCATION

# Deploy MS Account
az container create `
  --resource-group $RESOURCE_GROUP `
  --name msaccount `
  --image nguyendaobach/msaccount-qe180006:latest `
  --dns-name-label msaccount-qe180006 `
  --ports 8081 `
  --environment-variables `
    SPRING_DATASOURCE_URL="jdbc:postgresql://dpg-d48b5o49c44c73b25vvg-a/accountdb_az1k" `
    SPRING_DATASOURCE_USERNAME="accountdb_az1k_user" `
    SPRING_DATASOURCE_PASSWORD="Y975hz3okJKOVi2hm9GgaSJzYkndnSst"

# Deploy MS Brand
az container create `
  --resource-group $RESOURCE_GROUP `
  --name msbrand `
  --image nguyendaobach/msbrand-qe180006:latest `
  --dns-name-label msbrand-qe180006 `
  --ports 8082 `
  --environment-variables `
    SPRING_DATASOURCE_URL="jdbc:postgresql://db.jndulnmnvtimrqfwideb.supabase.co:5432/postgres" `
    SPRING_DATASOURCE_USERNAME="postgres" `
    SPRING_DATASOURCE_PASSWORD="bach@129052004"

# Deploy MS BlindBox
az container create `
  --resource-group $RESOURCE_GROUP `
  --name msblindbox `
  --image nguyendaobach/msblindbox-qe180006:latest `
  --dns-name-label msblindbox-qe180006 `
  --ports 8083 `
  --environment-variables `
    SPRING_DATASOURCE_URL="jdbc:postgresql://db.cdttwujwmdeeznblpzoi.supabase.co:5432/postgres" `
    SPRING_DATASOURCE_USERNAME="postgres" `
    SPRING_DATASOURCE_PASSWORD="bach@129052004"

# Deploy API Gateway (sau khi có URL của 3 services trên)
az container create `
  --resource-group $RESOURCE_GROUP `
  --name apigateway `
  --image nguyendaobach/apigateway-qe180006:latest `
  --dns-name-label apigateway-qe180006 `
  --ports 8080 `
  --environment-variables `
    SPRING_CLOUD_GATEWAY_ROUTES_0_URI="http://msaccount-qe180006.southeastasia.azurecontainer.io:8081" `
    SPRING_CLOUD_GATEWAY_ROUTES_1_URI="http://msblindbox-qe180006.southeastasia.azurecontainer.io:8083" `
    SPRING_CLOUD_GATEWAY_ROUTES_2_URI="http://msbrand-qe180006.southeastasia.azurecontainer.io:8082"

Write-Host "Deployed successfully!"
Write-Host "API Gateway: http://apigateway-qe180006.southeastasia.azurecontainer.io:8080"
