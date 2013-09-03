if (!global.hasOwnProperty('db')) {
    var Sequelize = require('sequelize');
    var sq = null;
 /*   var fs = require('fs');
    var PGPASS_FILE = '../.pgpass'; */
    console.log ("Database=" + process.env.DATABASE_URL);
    if (process.env.DATABASE_URL) {
        /* Database
           Do `heroku config` for details. We will be parsing a connection
           string of the form:
           postgres://user:password@host:port/dbname
        */
        var pgregex = /postgres:\/\/([^:]+):([^@]+)@([^:]+):(\d+)\/(.+)/;
        var match = process.env.DATABASE_URL.match(pgregex);
        var user = match[1];
        var password = match[2];
        var host = match[3];
        var port = match[4];
        var dbname = match[5];
        var config =  {
            dialect:  'postgres',
            protocol: 'postgres',
            port:     port,
            host:     host,
            logging:  true //false
        };
        sq = new Sequelize(dbname, user, password, config);
        global.db = {
        Sequelize: Sequelize,
        sequelize: sq,
        Order: sq.import(__dirname + '/order')
        };
    } else {
        return new Error ("DATABASE_URL not set");
    }
}
module.exports = global.db;
