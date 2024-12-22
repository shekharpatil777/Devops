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
        stage('login') {
            steps {
                 echo "docker build"
                 withCredentials([usernamePassword(credentialsId: 'cp-dockerhub', passwordVariable: 'dockerhubpwd', usernameVariable: 'dockerhubUser')]) {
                          sh ' echo ${dockerhubpwd} | docker login -u  ${dockerhubUser} --password-stdin'
                                 }
            }
        }
        stage('build') {
            steps {
                 echo "docker build"
                 //sh 'sudo usermod -a -G docker ec2-user'
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
