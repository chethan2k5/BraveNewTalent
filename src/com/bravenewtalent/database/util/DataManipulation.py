#!/usr/bin/python
'''
Created on Apr 5, 2014
BraveNewTalent Technical test Problem 2

@author: chethan
'''
from numpy import median
from numpy import mean
from numpy import max
from numpy import min
from numpy import std
from datetime import datetime

# input sequence of dictionaries containing user profiles

users = [{ 'id': 40, 'name': 'Joe Bloggs', 'posts': 4 },\
               { 'id': 567, 'name': 'Jenny Smith', 'posts': 3 },\
               { 'id': 3, 'name': 'Frank Jones', 'posts': 54 },\
               { 'id': 46, 'name': 'Samantha Wills', 'posts': 0 },\
               { 'id': 6789, 'name': 'Ahmed Joseph Naran', 'posts': 15}]

def getTimeDifferenceValue(td):
    """ Get time difference values from previous time to current time and return time in minutes,hours,days and months ago"""
    SECOND = 1
    MINUTE = 60 * SECOND
    HOUR = 60 * MINUTE
    DAY = 24 * HOUR
    WEEK = 7 * DAY
    MONTH = 30 * DAY
    
    timenow = datetime.now();
    difference = timenow - td;

    delta =  difference.days * DAY + difference.seconds 
    
    minutes = delta / MINUTE
    hours = delta / HOUR
    days = delta / DAY
    weeks = delta / WEEK
    months = delta / MONTH
    
    if delta < 0:
        return "Please give time after current time"
    if delta < 10 * SECOND:
        return "just now" 
    if delta < 1 * MINUTE:    
        return str(delta) + " seconds ago"
    if delta < 60 * MINUTE:    
        return str(minutes) + " minutes ago"
    if delta < 24 * HOUR:
        return str(hours) + " hours ago"
    if delta < 1 * WEEK:
        return "one week ago"
    if delta < 4 * WEEK:
        return str(weeks) + " weeks ago"
    if delta < 1 * DAY:    
        return "one day ago"
    if delta < 30 * DAY:    
        return str(days) + " days ago"
    if delta < 1 * MONTH:    
        return "one month ago"
    else:
        return str(months) + " months ago"
        
def removeUsersWithNoPosts(users):
    """ Remove users with no posts that is users with posts equal to 0"""
    return [user for user in users if user.has_key('posts') and user['posts'] > 0]

def sortUsers(users, key = True):
    """ Sort users based on posts in descending order"""
    return sorted(users, key=lambda user: user['posts'], reverse = key)

def printStatistics(users):
    """ Use NumPy stat module to get stats of profile posts"""
    posts = [user['posts'] for user in users if user.has_key('posts')]
    print 'minimum of posts',min(posts)
    print 'maximum of posts',max(posts)
    print 'average of posts', mean(posts)
    print 'median of posts',median(posts)
    print 'standard deviation of posts',round(std(posts),1)

# Question 2 difference time

print "Question 2A difference between current and previous time"
postedTime = datetime(2014, 3, 23, 12, 44, 23)

print getTimeDifferenceValue(postedTime), '\n'

# Question 2 remove users with no posts and sort users
print "Question 2B sort users and remove posts with 0"
print sortUsers(removeUsersWithNoPosts(users), key = True),'\n'

# Question 2 get stats
print "Question 2C print statistics"
printStatistics(users)