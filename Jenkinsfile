pipeline {
    agent any

    triggers {
        githubPush()
    }

    environment {
        DOCKER_IMAGE = 'rachmadandy/book-library'
        DOCKER_TAG = 'latest'
        STAGING_PORT = '18765'
    }

    stages {
        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
            }
        }

        stage('Cucumber Acceptance Test') {
            steps {
                // Jalankan container untuk testing
                sh "docker stop book-library-test || true"
                sh "docker rm book-library-test || true"
                sh "docker run -d -p ${STAGING_PORT}:8080 --name book-library-test ${DOCKER_IMAGE}:${DOCKER_TAG}"
                sh 'sleep 5'

                // Jalankan cucumber test di dalam container
                sh "docker exec -e BOOK_LIBRARY_URL=http://localhost:8080 book-library-test bundle exec cucumber features/ --publish-quiet"
            }
        }

        // stage('Login & Push to Docker Registry') {
        //     steps {
        //         withCredentials([usernamePassword(
        //             credentialsId: 'dockerhub-creds',
        //             usernameVariable: 'DOCKER_USER',
        //             passwordVariable: 'DOCKER_PASS'
        //         )]) {
        //             sh "echo \$DOCKER_PASS | docker login -u \$DOCKER_USER --password-stdin"
        //             sh "docker push ${DOCKER_IMAGE}:${DOCKER_TAG}"
        //         }
        //     }
        // }

    }

    post {
        always {
            sh "docker stop book-library-test || true"
            sh "docker rm book-library-test || true"
        }
        success {
            echo 'Pipeline PASSED - Book Library siap deploy!'
        }
        failure {
            echo 'Pipeline FAILED - Cek logs untuk detail.'
        }
    }
}
