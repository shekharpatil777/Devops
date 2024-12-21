pipeline {
    agent  any
    
    stages {
        stage('pull') {
            steps {
               echo "git pull"
            }
        }
        stage('build') {
            steps {
                 echo "docker build"
            }
        }
        stage('push') {
            steps {
               echo "push image"
            }
        }
    }
}
