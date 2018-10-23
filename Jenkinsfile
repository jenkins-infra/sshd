#!/usr/bin/env groovy

def imageName = 'jenkinsciinfra/sshd'

properties([
    buildDiscarder(logRotator(numToKeepStr: '5', artifactNumToKeepStr: '5')),
    pipelineTriggers([[$class:"SCMTrigger", scmpoll_spec:"H/15 * * * *"]]),
])

node('docker') {
    def container
    def configHash
    def imageTag
    stage('Prepare Container') {
        timestamps {
            checkout scm
            dir('config/authorized_keys') {
                configHash = sh(script: 'cat $(cat ../../users.evergreen) ../sshd_config | md5sum', returnStdout: true).take(6)
            }

            imageTag = "evergreen-${configHash}"
            echo "Creating the container ${imageName}:${imageTag}"
            sh "docker build -t ${imageName}:${imageTag} -f Dockerfile ."
        }
    }

    /* Assuming we're not inside of a pull request or multibranch pipeline */
    if (!(env.CHANGE_ID || env.BRANCH_NAME)) {
        stage('Publish container') {
            infra.withDockerCredentials {
                timestamps {
                  sh "docker push ${imageName}:${imageTag}"
                }
            }
        }
    }
}

