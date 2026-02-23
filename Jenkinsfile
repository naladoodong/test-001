pipeline {
    agent any
    environment {
        DOCKER_CREDENTIALS_ID = 'docker-credentials-id'
        APP_NAME              = 'my-node-app'
        IMAGE_NAME            = "worldvit/${APP_NAME}"
        IMAGE_TAG             = "v${env.BUILD_NUMBER}"
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/worldvit/jenkins-cicd.git'
                script {
                    // 마지막 커밋 메시지를 추출하여 환경 변수에 저장
                    env.GIT_COMMIT_MSG = sh(script: 'git log -1 --pretty=%B', returnStdout: true).trim()
                }
            }
        }
        stage('Build & Push') {
            steps {
                script {
                    docker.withRegistry('', "${DOCKER_CREDENTIALS_ID}") {
                        // 빌드 시 환경 변수(커밋 메시지)를 이미지 안에 주입
                        def customImage = docker.build("${IMAGE_NAME}:${IMAGE_TAG}", "--build-arg COMMIT_MSG=\"${env.GIT_COMMIT_MSG}\" .")
                        customImage.push()
                        customImage.push('latest')
                    }
                }
            }
        }
        stage('Deploy') {
            steps {
                sh "docker rm -f ${APP_NAME} || true"
                // 컨테이너 실행 시 환경 변수 전달
                sh "docker run -d -p 3000:3000 --name ${APP_NAME} -e COMMIT_MSG=\"${env.GIT_COMMIT_MSG}\" ${IMAGE_NAME}:${IMAGE_TAG}"
            }
        }
    }
}
