# Deploy to Fly.io
# Yêu cầu: flyctl đã cài đặt (https://fly.io/docs/hands-on/install-flyctl/)

# Login
flyctl auth login

# Deploy MS Account
flyctl launch --image nguyendaobach/msaccount-qe180006:latest --name msaccount-qe180006 --internal-port 8081 --env SPRING_DATASOURCE_URL="jdbc:postgresql://dpg-d48b5o49c44c73b25vvg-a/accountdb_az1k" --env SPRING_DATASOURCE_USERNAME="accountdb_az1k_user" --env SPRING_DATASOURCE_PASSWORD="Y975hz3okJKOVi2hm9GgaSJzYkndnSst"

# Deploy MS Brand
flyctl launch --image nguyendaobach/msbrand-qe180006:latest --name msbrand-qe180006 --internal-port 8082 --env SPRING_DATASOURCE_URL="jdbc:postgresql://db.jndulnmnvtimrqfwideb.supabase.co:5432/postgres" --env SPRING_DATASOURCE_USERNAME="postgres" --env SPRING_DATASOURCE_PASSWORD="bach@129052004"

# Deploy MS BlindBox
flyctl launch --image nguyendaobach/msblindbox-qe180006:latest --name msblindbox-qe180006 --internal-port 8083 --env SPRING_DATASOURCE_URL="jdbc:postgresql://db.cdttwujwmdeeznblpzoi.supabase.co:5432/postgres" --env SPRING_DATASOURCE_USERNAME="postgres" --env SPRING_DATASOURCE_PASSWORD="bach@129052004"

# Deploy API Gateway
flyctl launch --image nguyendaobach/apigateway-qe180006:latest --name apigateway-qe180006 --internal-port 8080 --env SPRING_CLOUD_GATEWAY_ROUTES_0_URI="http://msaccount-qe180006.fly.dev:8081" --env SPRING_CLOUD_GATEWAY_ROUTES_1_URI="http://msblindbox-qe180006.fly.dev:8083" --env SPRING_CLOUD_GATEWAY_ROUTES_2_URI="http://msbrand-qe180006.fly.dev:8082"
