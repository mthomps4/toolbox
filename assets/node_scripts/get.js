require('dotenv').config()
const { google } = require('googleapis');
const compute = google.compute('v1');

async function main () {
  const auth = new google.auth.GoogleAuth({
    scopes: ['https://www.googleapis.com/auth/compute']
  });
  const authClient = await auth.getClient();

  // obtain the current project Id
  const project = await auth.getProjectId();

  // Fetch the list of GCE zones within a project.
  const res = await compute.zones.list({ project, auth: authClient });
  console.log(res.data);
  return res.data;
}

module.exports = function get() {
  return main().catch(console.error);
}