/*

@author : chethan
BraveNewTalent technical test - QueryDesign Problem solution

I have written the queries based on my understanding of the database. 
There is always scope for improving the query if i can understand the database better.
If you have any questions in my assumptions feel free to reach out to me at cmittapalli1@babson.edu
*/ 

/*

Created test bravenewtalent database with these tables for testing purposes

create table content_topic(id int, name varchar(150), follower_count int,created timestamp, updated timestamp, primary key(id));

create table content_item( id int, type varchar(63), pending boolean, source varchar(63), author_id int, author_type varchar(63), message text, slug varchar(200), recipient_id int, recipient_type varchar(63), like_count int, comment_count int, learn_count int, created timestamp, updated timestamp, private boolean, title text, segments int, primary key(id));

create table content_item_hash(item_id int references content_item(id), hash varchar(64));

create table content_item_comment(id integer, item_id int references content_item(id), author_id int,author_type varchar(62),message text, like_count int,created timestamp, updated timestamp, primary key(id));

create table content_item_participation(item_id int references content_item(id), profile_id int, profile_type varchar(62),comment_id int, liked timestamp, learned timestamp, hidden timestamp, flagged timestamp, posted timestamp, updated timestamp, primary key(item_id,profile_id,comment_id));

create table content_follow(follower_id int, target_id int, created timestamp, follower_type varchar(62), target_type varchar(62), primary key(follower_id,target_id));
*/

/* First query to get list of active members of the site invited by a organisation with profile_id 500 
ordered by the number of posts and then by the number of comments they have made. 
*/

select posts.author_id, posts.number_of_posts, comments.number_of_comments from 
	(select content.author_id as author_id, count(*) as number_of_posts 
	from content_item_participation participation,content_item content  
	where profile_id ='500' and participation.item_id=content.id group by author_id)
	as posts 
	join 
	(select content_item_comment.author_id as author_id,count(*) as number_of_comments 
	from content_item_comment where content_item_comment.author_id in 
		(select distinct cont.author_id from content_item_participation part,content_item cont 
		 where profile_id ='500' and part.item_id=cont.id) group by content_item_comment.author_id)
	as comments 
	on (posts.author_id = comments.author_id) order by posts.author_id;


/* Second query to get a query that shows the number of posts, comments, likes made in the last week by these active members. 
I am not sure on how to get likes from the database tables as we are only storing number_of_likes for posts and nothing in specific
for each user profile. I need to understand database better and an example snapshot can help me come up with a query easily
*/

select posts.author_id, posts.number_of_posts, comments.number_of_comments from 
	(select content.author_id as author_id, count(*) as number_of_posts 
	from content_item_participation participation,content_item content  
	where profile_id ='500' and participation.item_id=content.id and HOUR(timediff(now(),created)) < 24*7 group by author_id)
	as posts 
	join 
	(select content_item_comment.author_id as author_id,count(*) as number_of_comments 
	from content_item_comment where content_item_comment.author_id in 
		(select distinct cont.author_id from content_item_participation part,content_item cont 
		 where profile_id ='500' and part.item_id=cont.id) and HOUR(timediff(now(),created)) < 24*7 group by content_item_comment.author_id)
	as comments 
	on (posts.author_id = comments.author_id) order by posts.author_id;


/* Third query to get a query that gets total count of the number of topics followed by members invited by the organisation. */

select content_follow.follower_id as follower_id, count(*) as number_of_topics 
from content_follow where content_follow.follower_id in 
	(select distinct cont.recipient_id from content_item_participation part,content_item cont 
	where profile_id ='500' and part.item_id = cont.id ) 
group by follower_id;

/* Test results for all queries run in mysql

+-----------+-----------------+--------------------+
| author_id | number_of_posts | number_of_comments |
+-----------+-----------------+--------------------+
|         1 |               2 |                  3 |
|         2 |               1 |                  2 |
+-----------+-----------------+--------------------+
2 rows in set (0.02 sec)

+-----------+-----------------+--------------------+
| author_id | number_of_posts | number_of_comments |
+-----------+-----------------+--------------------+
|         1 |               2 |                  3 |
|         2 |               1 |                  2 |
+-----------+-----------------+--------------------+
2 rows in set (0.00 sec)

+-------------+------------------+
| follower_id | number_of_topics |
+-------------+------------------+
|           1 |                3 |
|           2 |                2 |
+-------------+------------------+
2 rows in set (0.00 sec)

*/

/* Find topics with maximum number of followers and order them*/

select content_follow.target_id as target_id, count(*) as number_of_followers 
from content_follow group by content_follow.target_id order by number_of_followers;

/* Find content types with maximum activity based on number of comments, likes and learn counts */

select content_activity.type as type, sum(total_count) from
	(select content_item.type as type, content_item.like_count + content_item.comment_count + content_item.learn_count 
	as total_count from content_item ) as content_activity
group by content_activity.type; 

/*

Results for additional queries

+-----------+---------------------+
| target_id | number_of_followers |
+-----------+---------------------+
|         8 |                   1 |
|         9 |                   1 |
|        10 |                   1 |
|         1 |                   1 |
|        11 |                   1 |
|         2 |                   1 |
+-----------+---------------------+
6 rows in set (0.00 sec)

+------------+------------------+
| type       | sum(total_count) |
+------------+------------------+
| technology |               45 |
+------------+------------------+
1 row in set (0.00 sec)

*/

