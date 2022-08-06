# azure.ghost-web-app-for-containers

A one-click [Ghost](https://ghost.org/)  deployment on [Azure Web App for Containers](https://azure.microsoft.com/en-us/services/app-service/containers/). The architecture is described in much greated detail below.

## Deploy

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FGitarPlayer%2Fazure.ghost-web-app-for-containers%2Fmaster%2Fghost.json)

## Acceptance Criterias
The Acceptance Criterias will be abbreviated with AC1 to AC6.
1. The application should be able to scale depending on the load. 
2. There should be no obvious security flaws.
3. The application must return consistent results across sessions.
4. The implementation should be built in a resilient manner.
5. Observability must be taken into account when implementing the solution.
6. The deployment of the application and environment should be automated.

## Functional Requirements
The Functional requirements will be abbreviated with FR1 to FR2.
1. The ghost blogging platform should be used
2. There is a serverless function that deletes all the posts

## Non Functional Requirements
The Non Functional Requirements will be abbreviated with NFR1 to NFR7.
1. the solution should be able to adapt to traffic spikes. It is expected that during the new product launch or marketing campaigns there could be increases of up to 4 times the typical load.
2. that the platform remains online even in case of a significant geographical failure.
3. interested in disaster recovery capabilities in case of a region failure.
4. The teams want to be able to release new versions of the application multiple times per day, without requiring any downtime.
5. The customer wants to have multiple separated environments
6. need tools to support theiroperations and help them with visualising and debugging the state of the environment
7. the security team also needs to have visibility into the platform and its operations

