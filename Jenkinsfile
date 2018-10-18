#!/usr/bin/env groovy

def imageName = 'jenkinsciinfra/sshd'

properties([
    buildDiscarder(logRotator(numToKeepStr: '5', artifactNumToKeepStr: '5')),
    pipelineTriggers([[$class:"SCMTrigger", scmpoll_spec:"H/15 * * * *"]]),
])

node('docker') {
    def container
    def configHash
    stage('Prepare Container') {
        timestamps {
            dir('config/authorized_keys') {
                sh 'tar cf - $$(cat ../../users.evergreen) | md5sum | cut -c1-6 > IMAGE_TAG'
                imageHash = readFile('IMAGE_TAG')
            }

            def imageTag = "evergreen-${configHash}"
            echo "Creating the container ${imageName}:${imageTag}"
            container = docker.build("${imageName}:${imageTag}")
        }
    }

    /* Assuming we're not inside of a pull request or multibranch pipeline */
    if (!(env.CHANGE_ID || env.BRANCH_NAME)) {
        stage('Publish container') {
            infra.withDockerCredentials {
                timestamps { container.push() }
            }
        }
    }
}

