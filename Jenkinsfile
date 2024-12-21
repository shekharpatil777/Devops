pipeline {
    agent  any
    environment {
        DOCKERHUB_CREDENTIALS = credentials('cp-dockerhub')   
    }
    stages {
        stage('pull') {
            steps {
               git branch: 'develop' ,  url: 'https://github.com/shekharpatil777/Devops.git' 
            }
        }
        stage('build') {
            steps {
                 echo "docker build"
                 sh 'docker build -t chandrashekharpatil/tourwebsite:latest .' 
            }
        }
        stage('push') {
            steps {
               echo "push image"
               sh 'docker push chandrashekharpatil/tourwebsite:latest'
            }
        }
    }
    post {
      always {
           sh 'docker logout'
        }
    }
}
