podTemplate(label: 'docker-build', 
  containers: [
    containerTemplate(
      name: 'git',
      image: 'alpine/git',
      command: 'cat',
      ttyEnabled: true
    ),
    containerTemplate(
      name: 'docker',
      image: 'docker',
      command: 'cat',
      ttyEnabled: true
    ),
  ],
  volumes: [ 
    hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock'), 
  ]
) {
    node('docker-build') {
        def dockerHubCred = 'sck1990'
        def appImage
        
        stage('Checkout'){
            container('git'){
                checkout scm
            }
        }
        

        stage('Build'){
            container('docker'){
                script {
                    appImage = docker.build("sck1990/node-hello-world")
                    step([
                        $class: 'com.amazon.inspector.jenkins.amazoninspectorbuildstep.AmazonInspectorBuilder',
                        sbomgenSource: 'linuxAmd64', // this can be linuxAmd64 or linuxArm64
                        archivePath: 'sck1990/node-hello-world',
                        awsRegion: 'ap-northeast-2',
                        credentialId: '3c90cd59-0160-46f9-bce3-8a51d4103f56',
                        isThresholdEnabled: false,
                        countCritical: 0,
                        countHigh: 0,
                        countLow: 10,
                        countMedium: 5,
                ])
                }
            }
        }
        


        stage('Test'){
            container('docker'){
                script {
                    appImage.inside {
                        //sh 'npm install'
                        //sh 'npm test'
                    }
                }
            }
        }

        stage('Push'){
            container('docker'){
                script {
                    docker.withRegistry('https://registry.hub.docker.com', dockerHubCred){
                        appImage.push("${env.BUILD_NUMBER}")
                        appImage.push("latest")
                    }
                }
            }
        }
    }
    
}

