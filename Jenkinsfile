@Library('ctsrd-jenkins-scripts') _

cheribuildArgs = ['--llvm/build-type=Release', // DEBUG builds are too slow, we use release + assertions
                  '--install-prefix=/', // This path is expected by downstream jobs
                  '--without-sdk', // Use host compilers
                  '--llvm/build-everything', // build all targets
                  '--llvm/install-toolchain-only', // but only install compiler+binutils
]
// Set job properties:
// Only archive artifacts for the default master and dev builds
def archiveArtifacts = false
def jobProperties = [rateLimitBuilds([count: 2, durationName: 'hour', userBoost: true]),
                     copyArtifactPermission('*'), // Downstream jobs need the compiler tarball
                     [$class: 'GithubProjectProperty', displayName: '', projectUrlStr: 'https://github.com/CTSRD-CHERI/llvm-project/'],
]
if (env.JOB_NAME.startsWith('CLANG-LLVM-linux/') || env.JOB_NAME.startsWith('CLANG-LLVM-freebsd/')) {
    // Skip pull requests and non-default branches:
    def archiveBranches = ['master', 'dev', 'upstream-llvm-merge']
    if (!env.CHANGE_ID && (archiveBranches.contains(env.BRANCH_NAME))) {
        archiveArtifacts = true
        cheribuildArgs.add("--use-all-cores")
        // For branches other than the master branch, only keep the last two artifacts to save disk space
        if (env.BRANCH_NAME != 'master') {
            jobProperties.add(buildDiscarder(logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '2')))
        }
    }
}
// Set the default job properties (work around properties() not being additive but replacing)
setDefaultJobProperties(jobProperties)

def nodeLabel = null
echo("JOB_NAME='${env.JOB_NAME}', JOB_BASE_NAME='${env.JOB_BASE_NAME}'")
if (env.JOB_NAME.toLowerCase().contains("linux")) {
    // Ensure that we can run the resulting binaries on all Linux slaves:
    nodeLabel = "linux-baseline"
} else if (env.JOB_NAME.toLowerCase().contains("freebsd")) {
    nodeLabel = "freebsd"
} else {
    error("Invalid job name: ${env.JOB_NAME}")
}

def TEST_RELEASE_BUILD = false
if (env.JOB_NAME.toLowerCase().contains("nodebug")) {
    TEST_RELEASE_BUILD = true
}
def TEST_WITH_SANITIZERS = false
if (env.JOB_NAME.toLowerCase().contains("sanitizer")) {
    TEST_WITH_SANITIZERS = true
}

cmakeArgs = [
        // Shared library builds are significantly slower
        '-DBUILD_SHARED_LIBS=OFF',
        // Avoid expensive checks (but keep assertions by default)
        '-DLLVM_ENABLE_EXPENSIVE_CHECKS=OFF',
        // link the C++ standard library statically (if possible)
        // This should make it easier to run binaries on other systems
        '-DLLVM_STATIC_LINK_CXX_STDLIB=ON',]
if (TEST_RELEASE_BUILD) {
    cheribuildArgs.add('--llvm/no-assertions')
} else {
    // Release build with assertions is a bit faster than a debug build and A LOT smaller
    cheribuildArgs.add('--llvm/assertions')
}
def individualTestTimeout = 300
if (TEST_WITH_SANITIZERS) {
    individualTestTimeout = 600  // Sanitizer builds are slow
    cheribuildArgs.add('--llvm/use-asan')
}
// By default max 1 hour total and max 2 minutes per test
cmakeArgs.add("-DLLVM_LIT_ARGS=--xunit-xml-output llvm-test-output.xml --max-time 3600 --timeout ${individualTestTimeout}")
// Quote and join the cmake args
cheribuildCmakeOption = '\'--llvm/cmake-options=\"' + cmakeArgs.join('\" \"') + '\"\''
echo("CMake options = ${cheribuildCmakeOption}")
cheribuildArgs.add(cheribuildCmakeOption)

Map defaultArgs = [target              : 'llvm-native', architecture: 'native',
                   customGitCheckoutDir: 'llvm-project',
                   nodeLabel           : nodeLabel,
                   fetchCheriCompiler  : false, // We are building the CHERI compiler, don't fetch it...
                   extraArgs           : cheribuildArgs.join(" "),
                   skipArchiving       : true,
                   skipTarball         : true,
                   tarballName         : "cheri-clang-llvm.tar.xz",
                   runTests            : true,
                   uniqueId            : env.JOB_NAME,
                   afterTests          : {
                       // Delete all files generated by the tests.
                       // The FreeBSD builders are currently configured with an ASCII locale.
                       // This causes recordIssues() step to fail due to the non-ASCII file
                       // names produced by some tests.
                       // FIXME: We should fix the FreeBSD build servers, but deleting the
                       //  files first so that they aren't scanned for warnings probably
                       //  helps speed up recordIssues() anyway.
                       sh "find llvm-project-build -type d -name Output -prune -exec rm -rf {} +"
                   },
                   junitXmlFiles       : "llvm-project-build/llvm-test-output.xml",
]

if (archiveArtifacts) {
    parallel "Build+Test": {
        node (nodeLabel) {
            // Run the full test suite
            def result = cheribuildProject(defaultArgs + [nodeLabel: null]) // already have a node
            // Run the libunwind+libcxxabi+libcxx tests to check we didn't regress native builds
            cheribuildProject(target: 'llvm-libs', architecture: 'native',
                    skipTarball: true, skipInitialSetup: true, // No need to checkout git
                    nodeLabel: null, buildStage: "Run libunwind+libcxxabi+libcxx tests",
                    // Ensure we test failures don't prevent creation of the junit file
                    extraArgs: '--keep-install-dir --install-prefix=/ --without-sdk',
                    // Set the status message on the current commit of the LLVM repo
                    gitHubStatusArgs: result.gitInfo,
                    uniqueId: "llvm-libraries/${env.JOB_BASE_NAME}/${nodeLabel}/",
                    runTests: true, junitXmlFiles: "llvm-libs-build/llvm-libs-test-results.xml")
        }
    }, "Build LTO": {
        // Build for archiving (with LTO, only toolchain binaries)
        String ltoCheribuildArgs = cheribuildArgs.join(" ")
        ltoCheribuildArgs = ltoCheribuildArgs.replace('--llvm/build-everything', '')
        ltoCheribuildArgs = ltoCheribuildArgs.replace('--llvm/install-toolchain-only', '')
        ltoCheribuildArgs += ' --llvm/use-lto --llvm/build-minimal-toolchain --llvm/build-all-targets'
        cheribuildProject(defaultArgs + [runTests : false,
                                         skipArchiving: false, skipTarball: false,
                                         uniqueId: env.JOB_NAME + "-LTO",
                                         extraArgs: ltoCheribuildArgs])
    }
} else {
    cheribuildProject(defaultArgs)
}
