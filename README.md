# fcsp_rad

Training for FCSP Rad

## Getting Started

For help getting started with Flutter, view our online
[documentation](https://flutter.io/).


## generating appsync classes
`
#android
amplify init
amplify add api
amplify add codegen --apiId <MY-API-ID>
amplify configure codegen
`
The amplify `codegen statements` command generates GraphQL statements(queries, mutation and subscription) based on your GraphQL schema. This command downloads introspection schema every time it is run
`
amplify codegen
amplify codegen statements
gradle generateApolloClasses
`

## generating json mappers from annotated classes for dart
`flutter packages pub run build_runner build`

API KEY is set in constants.dart
AWS_APP_SYNC_KEY