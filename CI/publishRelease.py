#!/usr/bin/python

import os
import sys
import time
import urllib2
import httplib
import base64
import json
from datetime import datetime

pid = -1
timestamp = None
datastring = ""

GH_BASE_URL = "https://api.github.com/"

GH_USER = os.environ['GH_USER']
GH_TOKEN = os.environ['GH_TOKEN']

def readUrl(name):
    global GH_BASE_URL

    try:
        base64string = base64.b64encode('%s:%s' % (GH_USER, GH_TOKEN))
        request = urllib2.Request(GH_BASE_URL + name)
        request.add_header("Authorization", "Basic %s" % base64string)
        content = urllib2.urlopen(request).read()
        jcont = json.loads(content)
        # clear file with exception count
        return jcont;
    except urllib2.HTTPError, e:
        print 'HTTPError = ' + str(e.code)
        raise e
    except urllib2.URLError, e:
        print 'URLError = ' + str(e.reason)
        raise e
    except httplib.HTTPException, e:
        print 'HTTPException = ' + str(e)
        raise e
    except Exception:
        import traceback
        print 'generic exception: ' + traceback.format_exc()
        raise IOError

def postUrl(name, body):
    global GH_BASE_URL
    try:
        time.sleep(0.05)
        base64string = base64.b64encode('%s:%s' % (GH_USER, GH_TOKEN))
        request = urllib2.Request(GH_BASE_URL + name)
        request.add_header("Authorization", "Basic %s" % base64string)
        request.add_header("Accept", "application/vnd.github.v3+json")
        content = urllib2.urlopen(request, body).read()
        jcont = json.loads(content)
        # clear file with exception count
        return jcont;
    except urllib2.HTTPError, e:
        print 'HTTPError = ' + str(e.code)
        print str(e)
        raise e
    except urllib2.URLError, e:
        print 'URLError = ' + str(e.reason)
        raise e
    except httplib.HTTPException, e:
        print 'HTTPException = ' + str(e)
        raise e
    except Exception:
        import traceback
        print 'generic exception: ' + traceback.format_exc()
        raise IOError

def invoke(name, body, method):
    global GH_BASE_URL

    try:
        base64string = base64.b64encode('%s:%s' % (GH_USER, GH_TOKEN))
        request = urllib2.Request(GH_BASE_URL + name)
        request.add_header("Authorization", "Basic %s" % base64string)
        content = urllib2.urlopen(request).read()
        # clear file with exception count
        return content;
    except urllib2.HTTPError, e:
        print 'HTTPError = ' + str(e.code)
        raise e
    except urllib2.URLError, e:
        print 'URLError = ' + str(e.reason)
        raise e
    except httplib.HTTPException, e:
        print 'HTTPException = ' + str(e)
        raise e
    except Exception:
        import traceback
        print 'generic exception: ' + traceback.format_exc()
        raise IOError


# pretty
def pretty(jcont):
    return json.dumps(jcont, sort_keys=True, indent=4, separators=(',', ': '))

def lastReleaseId(tag):
    content = readUrl('repos/frantuma/nagger-core/releases')
    for l in content:
        draft = l["draft"]
        print str(draft)
        draft_tag = l["tag_name"]
        if str(draft) == 'True' and tag == draft_tag:
            return l["id"]

def publishRelease(tag):
    id = lastReleaseId(tag)
    print 'id ' + str(id)
    payload = "{\"tag_name\":\"" + tag + "\", "
    payload += "\"draft\":" + "false" + ", "
    payload += "\"target_commitish\":\"" + "master" + "\"}"
    print payload
    content = postUrl('repos/frantuma/nagger-core/releases/' + str(id), payload)
    return content

def getReleases():
    content = readUrl('repos/frantuma/nagger-core/releases')
    return content

# main
def main(tag):
    print tag
    print publishRelease (tag)

# here start main
main(sys.argv[1])
