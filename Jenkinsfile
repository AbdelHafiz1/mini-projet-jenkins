pipeline{
    environment {
        IMAGE_NAME ="website_img"
        IMAGE_TAG ="latest"
        STAGING = "abdelhafiz2-website-staging"
        PRODUCTION = "abdelhafiz2-website-prod"
        ENDPOINT="http://10.0.21.4"
        DOCKERHUB_CREDENTIALS = credentials('dockerhub_passowrd')
    }
    agent none
    stages{
        stage('Build image'){
            agent any
            steps{
                script {
                    sh 'docker build -t abdelhafiz2/$IMAGE_NAME:$IMAGE_TAG .' 
                }
            }
        }
        stage('Delete container if exist'){
            agent any
            steps{
                script {
                    sh '''
                    docker rm -f $IMAGE_NAME || echo "Container does not exist"
                    
                    '''
                }
            }
        }
        stage('Run container'){
            agent any
            steps{
                script {
                    sh '''
                    docker run --name=$IMAGE_NAME -dp 83:80 -e PORT=80 abdelhafiz2/$IMAGE_NAME:$IMAGE_TAG
                    sleep 5
                    
                    '''
                }
            }
        }

        stage('Test image'){
            agent any
            steps{
                script {
                    sh '''
                    curl $ENDPOINT:83 | grep "Dimension"
                    
                    '''
                }
            }
        }

        stage('Push Image on DockerHUB'){
            agent any
            steps{
                script {
                    sh '''
                    echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin
                    docker push  abdelhafiz2/$IMAGE_NAME:latest
            
                    '''
                }
            }
        }

        stage('Clean container'){
            agent any
            steps{
                script {
                    sh '''
                    docker stop $IMAGE_NAME
                    docker rm $IMAGE_NAME
                    '''
                }
            }
        }
        stage('push imahe in staging and deploy'){
            when{
                expression { GIT_BRANCH == 'origin/master'}
            }
            agent any
            environment{
                HEROKU_API_KEY = credentials('heroku_api_key')
            }
            steps{
                script {
                    sh '''
                    npm i -g heroku@7.68.0
                    heroku container:login
                    heroku create $STAGING || echo "project already exist"
                    heroku stack:set container --app $STAGING
                    heroku container:push -a $STAGING web
                    heroku container:release -a $STAGING web
                    
                    '''
                }
            }
        }
        stage('push imahe in PRODUCTION and deploy'){
            when{
                expression { GIT_BRANCH == 'origin/master'}
            }
            agent any
            environment{
                HEROKU_API_KEY = credentials('heroku_api_key')
            }
            steps{
                script {
                    sh '''
                  npm i -g heroku@7.68.0
                  heroku container:login
                  heroku create $PRODUCTION || echo "project already exist"
                  heroku container:push -a $PRODUCTION web
                  heroku container:release -a $PRODUCTION web
                    
                    '''
                }
            }
        }
    }
}
