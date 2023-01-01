workspace "Recommendation Engine" {

    model {
        website = softwareSystem "E-Commerce Website" "E-commerce website that displays recommendations to a user" "External System"

        ecommDatabase = softwareSystem "E-Commerce Database" "Contains user, items and interaction data" "External System"

        recommendationEngine = softwareSystem "Recommendation Engine" "Creates item recommendations for an e-commerce website" {
            website -> this "Gets recommendations from"
            website -> this "Sends live data to"
            ecommDatabase -> this "Sends items, users and interactions data to"
            
            apiApp = container "API Application" "Provides APIs to store data and get recommendations" {
                website -> this "Gets recommendations from"
                website -> this "Sends live data to"
                ecommDatabase -> this "Sends historical users, items and interactions data to"
            }

            securityAndAuth = container "Security & Auth" "Uses Cogntio and WAF" {
                this -> apiApp "Provides Authentication and Security for"
            }

            database = container "Database" "S3 bucket for Amazon Personalize" {
                apiApp -> this "Stores data in"
            }

            amzPersonalize = container "Amazon Personalize" "Uses data, trains models and provides recommendations" {
                apiApp -> this "Sends live data to"
                apiApp -> this "Gets recommendations from"
                this -> database "Gets historical data from"
            }
        }
        
    }

    views {
        systemContext recommendationEngine "RecommendationEngine" {
            include *
        }

        container recommendationEngine {
            include *
        }

        theme default

        styles {
            element "External System" {
                background #999999
            }
        }
    }

}