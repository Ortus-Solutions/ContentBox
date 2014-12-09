[
	{
        "securelist": "^contentbox-admin:(authors|categories|permissions|roles|settings|pages|entries|contentstore|securityrules)\\.importAll$",
        "roles": "",
        "permissions": "TOOLS_IMPORT",
        "whitelist": "",
        "redirect": "cbadmin/security/login",
        "order": "20",
        "match": "event",
        "useSSL": false
    },
    {
        "securelist": "^contentbox-admin:(authors|categories|permissions|roles|settings|pages|entries|contentstore|securityrules)\\.(export|exportAll)$",
        "roles": "",
        "permissions": "TOOLS_EXPORT",
        "whitelist": "",
        "redirect": "cbadmin/security/login",
        "order": "20",
        "match": "event",
        "useSSL": false
    }
]
