# Salesforce Star Wars Integration
### _[Salesforce Mentor - Build Together](https://courses.salesforcementor.com/)_

A month-long project you build on a team of 2-3 with other learning Salesforce developers. Small teams will work together to complete development assignments. A weekly meeting with experienced developers to go over questions and review code. Get actual hands-on experience by working on projects, in a team with requirements.

![Screen Shot 2023-02-16 at 2 32 24 PM](https://user-images.githubusercontent.com/94694097/219456664-1d86b2b7-b993-4923-af06-613ba4b90a1f.png)
![Screen Shot 2023-02-16 at 2 32 48 PM](https://user-images.githubusercontent.com/94694097/219456669-03582a5c-a341-4173-83b8-f477a2de2da7.png)
![Screen Shot 2023-02-16 at 2 33 00 PM](https://user-images.githubusercontent.com/94694097/219456674-38f2b59d-c9e1-43c5-a7d3-68ba909b9cc2.png)
![Screen Shot 2023-02-16 at 2 33 11 PM](https://user-images.githubusercontent.com/94694097/219456677-cf9c1c5c-ecb2-4f18-a0cc-b0c0a1c10840.png)


## Overview
Create an integration to retrieve Star Wars information from [SWAPI](https://swapi.dev/) and store that information into standard Salesforce objects.
Practice Skills
- Apex Fundamentals 
- REST Integrations
- Data Transformation
- DML Operations

## Project Requirements  
- REST Callout to SWAPI for Planets, People, Starships
- Process API responses  in individual wrapper classes per resource
- Put processed data into Salesforce objects

## Getting Started
- Fork this repository and (if team leader) [invite team members to repo](https://docs.github.com/en/account-and-profile/setting-up-and-managing-your-personal-account-on-github/managing-access-to-your-personal-repositories/inviting-collaborators-to-a-personal-repository) 
- Clone the forked repo onto your local computer and open the folder in Visual Studio Code
- Connect to your playground org and start coding! 

## Development Requirements
- Must have completed and sent a review of Apex Fundamentals
- Must use SFDX, git, GitHub, and Visual Studio Code
- Your code should be able to run in any playground org via a GitHub repo
- Must be able to commit to meeting weekly with a large group
- Do not use configuration automation or middleware to do integration

## Resources
- [Star Wars API](https://swapi.dev/)
- [Trailhead - Apex Integration Services](https://trailhead.salesforce.com/content/learn/modules/apex_integration_services)
- [Apex Recipies - Integration Examples](https://github.com/trailheadapps/apex-recipes/tree/main/force-app/main/default/classes/Integration%20Recipes)
- [Trailhead - Set Up Visual Studio Code](https://trailhead.salesforce.com/content/learn/projects/quick-start-lightning-web-components/set-up-visual-studio-code)

## Notes
- Build Together is meant to be challenging. You will be asked to figure things out with your team. Sr. Dev will guide you but not a full outline of what you should be doing. Asking questions is the more important thing.
- You can use other resources but don’t just copy it word for word. You should be able to explain what your code is doing.
- Team members are meant to keep each other accountable, but if a team member is not pulling their weight, they will be cut.

## App Description
- The first attempt at making the REST API request to SWAPI.com used an invocable method to make the callout based on a users selction in a screen flow. The URL endpoints were stored in a custom metatdata object in the background that would populate the Apex Class to make the callout and create a new Planet record based on the data from the API
- The second revision of this project was creating a scheduled Apex class that would run every night to upsert the data in the org. An external ID was used to match the data from the API to the associated Salesforce record. 

## Read All About It

- [Salesforce Extensions Documentation](https://developer.salesforce.com/tools/vscode/)
- [Salesforce CLI Setup Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_intro.htm)
- [Salesforce DX Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_intro.htm)
- [Salesforce CLI Command Reference](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference.htm)

## License

MIT

**Free Software, Hell Yeah!**
