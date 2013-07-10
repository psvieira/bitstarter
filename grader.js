#!/usr/bin/env node
/*
Automatically grade files for the presence of specified HTML tags/attributes.
Uses commander.js and cheerio
*/

var fs = require('fs');
var program = require('commander');
var cheerio = require('cheerio');
var rest = require('restler');
var HTMLFILE_DEFAULT = "index.html";
var CHECKSFILE_DEFAULT = "checks.json";
var WORKFILE = "work.html";

var assertFileExists = function(infile) {
	var instr = infile.toString();
	if (!fs.existsSync(instr)) {
		console.log("%s does not exist. Exiting.", instr);
		process.exit(1);
	}
	return instr;
};

var checkHtmlFile = function(htmlfile, checksfile) {
	html = cheerio.load(fs.readFileSync(htmlfile));
	var checks = JSON.parse(fs.readFileSync(checksfile)).sort();
	var out = {};
	for (var ii in checks) {
		var present = html(checks[ii]).length > 0;
		out[checks[ii]] = present;
	}
	return out;
};

var clone = function(fn) {
	// workaround for commander.js issue.
	// http://stackoverflow.com/a/6772648
	return fn.bind({});
};

if (require.main == module) {
	program
		.option('-c, --checks <check_file>', 'Path to checks.json', clone(assertFileExists),
			CHECKSFILE_DEFAULT)
		.option('-f, --file <html_file>', 'Path to index.html', clone(assertFileExists),
			HTMLFILE_DEFAULT)
		.option('-u, --url <html_url', 'URL of HTML page')
		.parse(process.argv);
	if (program.url) {
		rest.get(program.url).on('complete', function (result, response) {
			if (result instanceof Error) {
				console.log('Error: ' + util.format(response.message));
			} else {
				fs.writeFileSync(WORKFILE, result);
				var checkJson = checkHtmlFile(WORKFILE, program.checks);
				var outJson = JSON.stringify(checkJson, null, 4);
				console.log(outJson);
			}
		});
	} else {
		var checkJson = checkHtmlFile(program.file, program.checks);
		var outJson = JSON.stringify(checkJson, null, 4);
		console.log(outJson);
	}
} else {
	exports.checkHtmlFile = checkHtmlFile;
}