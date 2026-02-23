pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS_ID = 'docker-credentials-id'
        APP_NAME              = 'my-node-app'
        IMAGE_NAME            = "m970306/${APP_NAME}"
        IMAGE_TAG             = "v${env.BUILD_NUMBER}"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/naladoodong/test-001.git'

                script {
                    // 마지막 커밋 메시지 추출
                    env.GIT_COMMIT_MSG = sh(
                        script: 'git log -1 --pretty=%B',
                        returnStdout: true
                    ).trim()
                }
            }
        }

        stage('Build & Push') {
            steps {
                script {
                    docker.withRegistry('', "${DOCKER_CREDENTIALS_ID}") {

                        // build-arg로 커밋 메시지 전달
                        def customImage = docker.build(
                            "${IMAGE_NAME}:${IMAGE_TAG}",
                            "--build-arg COMMIT_MSG=\"${env.GIT_COMMIT_MSG}\" ."
                        )

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
                sh """
                   docker run -d \
                   -p 3000:3000 \
                   --name ${APP_NAME} \
                   -e COMMIT_MSG="${env.GIT_COMMIT_MSG}" \
                   ${IMAGE_NAME}:${IMAGE_TAG}
                """
            }
        }
    }
}

