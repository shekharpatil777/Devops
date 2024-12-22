pipeline {
    agent  any
    environment {
        DOCKERHUB_CREDENTIALS = credentials('cp-dockerhub')
        BUILD_NUMBER = "${env.BUILD_NUMBER}" 
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
                 sh "echo Building with build number: ${env.BUILD_NUMBER}"
                 sh 'docker build -t chandrashekharpatil/tourwebsite:${BUILD_NUMBER} .' 
            }
        }
        stage('push') {
            steps {
               echo "push image"
               sh 'docker push chandrashekharpatil/tourwebsite:${BUILD_NUMBER}'
    post {
      always {
           sh 'docker logout'
        }
    }
}
