async function get_all_versions() {
    const response = await fetch("https://nodejs.org/dist/index.json");
    const data = await response.json();
    return data;
}
async function printLtsVersions(versions) {
    const include = [];
    let firstLts = false;
    versions.filter((version) => !!version.lts).forEach((version) => {
        let latest = false;
        const ltsVersion = version.version
        const majorVersion = ltsVersion.split('.')[0].slice(1)
        if (firstLts) {
            firstLts = false;
            latest = true;
        } else {
            latest = false;
        }
        if (majorVersion >= 16) {
            include.push({
                'node-version': ltsVersion,
                'major-version': majorVersion,
                'latest': latest,
            });
        }
    });
    console.log(JSON.stringify({include}));
}

const versions = await get_all_versions();
printLtsVersions(versions);