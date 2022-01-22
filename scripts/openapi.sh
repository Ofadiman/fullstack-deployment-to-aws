#!/usr/bin/env bash

# The script is responsible for generating OpenAPI documentation in the client folder.
# For the script to work properly, you must create the `.env.development` file in the `scripts` folder and add the appropriate environment variables to it.
#   - `SWAGGER_URL` - An environment variable that specifies where the JSON with the documentation should be fetched from. In the current configuration, the backend provides documentation under `http://localhost:3001/docs-json`.
#   - `SWAGGER_USERNAME` - An environment variable that specifies the user name required when accessing documentation. In the current configuration, the backend sets the username as `admin`.
#   - `SWAGGER_PASSWORD` - Environment variable specifying the user password required when accessing documentation. In the current configuration, the backend sets the user password as `password`.

ENV_FILE="./scripts/.env.development"

echo "Loading environment variables from \"${ENV_FILE}\" file."

SWAGGER_URL=$(grep SWAGGER_URL "./scripts/.env.development" | sed "s/SWAGGER_URL=//g")
SWAGGER_USERNAME=$(grep SWAGGER_USERNAME "./scripts/.env.development" | sed "s/SWAGGER_USERNAME=//g")
SWAGGER_PASSWORD=$(grep SWAGGER_PASSWORD "./scripts/.env.development" | sed "s/SWAGGER_PASSWORD=//g")

echo "Fetching swagger documentation from \"${SWAGGER_URL}\"."
curl -u ${SWAGGER_USERNAME}:${SWAGGER_PASSWORD} -s ${SWAGGER_URL} -o swagger.json
echo "Successfully fetched swagger documentation from \"${SWAGGER_URL}\"."

echo "Generating OpenAPI code in client directory."
openapi --input ./swagger.json --output ./packages/client/src/openapi
echo "Successfully generated OpenAPI code in client directory."

echo "Deleting temporary \"swagger.json\" file."
rm swagger.json
echo "Successfully deleted temporary \"swagger.json\" file."
