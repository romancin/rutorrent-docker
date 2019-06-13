pipeline {
  environment {
    registry = "romancin/rutorrent-docker"
    registryCredential = 'dockerhub'
  }
  agent any
  stages {
    stage('Cloning Git Repository') {
      steps {
        git url: 'https://github.com/romancin/rutorrent-docker.git',
            branch: 'master'
      }
    }
    stage('Building image and pushing it to the registry') {
            steps {
                script {
                    def version = readFile('VERSION')
                    def versions = version.split('\\.')
                    def major = '0.9.7-' + versions[0]
                    def minor = '0.9.7-' + versions[0] + '.' + versions[1]
                    def patch = '0.9.7-' + version.trim()
                    def latest = 'latest'
                    docker.withRegistry('', registryCredential) {
                        def image = docker.build registry + ":0.9.7"
                        image.push()
                        image.push(latest)
                        image.push(major)
                        image.push(minor)
                        image.push(patch)
                    }
                }
            }
    }
 }
}
