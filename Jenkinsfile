def secrets = [
    [path: 'secret/services/dockerhub', engineVersion: 2, secretValues: [
        [envVar: 'DOCKERHUB_USERNAME', vaultKey: 'username'],
        [envVar: 'DOCKERHUB_PASSWORD', vaultKey: 'password']]],
    [path: 'secret/notifications/discord', engineVersion: 2, secretValues: [
        [envVar: 'DISCORD_WEBHOOK', vaultKey: 'webhook']]],
    [path: 'secret/services/maxmind', engineVersion: 2, secretValues: [
        [envVar: 'MAXMIND_LICENSE_KEY', vaultKey: 'webhook']]],
  ]

registry="romancin/rutorrent"

podTemplate(label: 'github-docker-builder', cloud: 'kubernetes',
  containers: [
    containerTemplate(name: 'buildkit', image: 'moby/buildkit:master', ttyEnabled: true, privileged: true),
    containerTemplate(name: 'docker-readme', image: 'sheogorath/readme-to-dockerhub', command: 'sleep', args: '99d'),
  ],
  volumes: [
    secretVolume(secretName: 'docker-config', mountPath: '/root/.docker')
  ]) {
       node('github-docker-builder') {
         stage('Cloning Git Repository') {
           container('buildkit') {
             git url: 'https://github.com/romancin/rutorrent-docker.git',
             branch: '$BRANCH_NAME'
           }
         }
         stage('Building image and pushing it to the registry (develop)') {
           if (env.BRANCH_NAME == 'develop') {
             def gitbranch = sh(returnStdout: true, script: 'git rev-parse --abbrev-ref HEAD').trim()
             def version = readFile('VERSION')
             def versions = version.split('\\.')
             def major = gitbranch + '-' + versions[0]
             def minor = gitbranch + '-' + versions[0] + '.' + versions[1]
             def patch = gitbranch + '-' + version.trim()
             container('buildkit') {
                withVault([vaultSecrets: secrets]) {
                 sh """
                      buildctl build --frontend dockerfile.v0 --local context=. --local dockerfile=. --output type=image,name=${registry}:${gitbranch},push=true
                      buildctl build --frontend dockerfile.v0 --local context=. --local dockerfile=. --output type=image,name=${registry}:${major},push=true
                      buildctl build --frontend dockerfile.v0 --local context=. --local dockerfile=. --output type=image,name=${registry}:${minor},push=true
                      buildctl build --frontend dockerfile.v0 --local context=. --local dockerfile=. --output type=image,name=${registry}:${patch},push=true
                    """
                }
             }
           }
         }
         stage('Building image and pushing it to the registry (main)') {
           if (env.BRANCH_NAME == 'master') {
             def gitbranch = sh(returnStdout: true, script: 'git rev-parse --abbrev-ref HEAD').trim()
             def version = readFile('VERSION')
             def versions = version.split('\\.')
             def major = '0.9.8-' + versions[0]
             def minor = '0.9.8-' + versions[0] + '.' + versions[1]
             def patch = '0.9.8-' + version.trim()
             container('buildkit') {
                withVault([vaultSecrets: secrets]) {
                 sh """
                      buildctl build --frontend dockerfile.v0 --local context=. --local dockerfile=. --build-arg BASEIMAGE_VERSION=3.14 --build-arg RTORRENT_VER=v0.9.8 --build-arg LIBTORRENT_VER=v0.13.8 --build-arg MAXMIND_LICENSE_KEY=${MAXMIND_LICENSE_KEY} --build-arg TARGETARCH=amd64 --output type=image,name=${registry}:latest,push=true
                      buildctl build --frontend dockerfile.v0 --local context=. --local dockerfile=. --build-arg BASEIMAGE_VERSION=3.14 --build-arg RTORRENT_VER=v0.9.8 --build-arg LIBTORRENT_VER=v0.13.8 --build-arg MAXMIND_LICENSE_KEY=${MAXMIND_LICENSE_KEY} --build-arg TARGETARCH=amd64 --output type=image,name=${registry}:${major},push=true
                      buildctl build --frontend dockerfile.v0 --local context=. --local dockerfile=. --build-arg BASEIMAGE_VERSION=3.14 --build-arg RTORRENT_VER=v0.9.8 --build-arg LIBTORRENT_VER=v0.13.8 --build-arg MAXMIND_LICENSE_KEY=${MAXMIND_LICENSE_KEY} --build-arg TARGETARCH=amd64 --output type=image,name=${registry}:${minor},push=true
                      buildctl build --frontend dockerfile.v0 --local context=. --local dockerfile=. --build-arg BASEIMAGE_VERSION=3.14 --build-arg RTORRENT_VER=v0.9.8 --build-arg LIBTORRENT_VER=v0.13.8 --build-arg MAXMIND_LICENSE_KEY=${MAXMIND_LICENSE_KEY} --build-arg TARGETARCH=amd64 --output type=image,name=${registry}:${patch},push=true
                    """
                }
             }
             container('docker-readme') {
               withEnv(['DOCKERHUB_REPO_NAME=tinymediamanager']) {
                 withVault([vaultSecrets: secrets]) {
                      sh """
                      export DOCKERHUB_USERNAME=${DOCKERHUB_USERNAME}
                      export DOCKERHUB_PASSWORD=${DOCKERHUB_PASSWORD}
                      rm -rf /data && ln -s `pwd` /data
                      cd /data && node --unhandled-rejections=strict /app/index.js
                      """
                 }
               }
             }
           }
         }
        stage('Notify Build Result') {
          withVault([vaultSecrets: secrets]) {
            discordSend description: "[Jenkins] - Pipeline CI-docker-tinymediamanager", footer: "", link: env.BUILD_URL, result: currentBuild.currentResult, title: JOB_NAME, webhookURL: "${DISCORD_WEBHOOK}"
          }
        }
       }
}


properties([[
    $class: 'BuildDiscarderProperty',
    strategy: [
        $class: 'LogRotator',
        artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '', numToKeepStr: '10']
    ]
]);
