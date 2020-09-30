

DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS question_likes;
PRAGMA foreign_keys = ON;

CREATE TABLE users(
    id INTEGER PRIMARY KEY,
    fname TEXT NOT NULL,
    lname TEXT NOT NULL
);

INSERT INTO 
    users(fname, lname)
VALUES
    ('Jae','Song');


CREATE TABLE questions(
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    author_id INTEGER NOT NULL,

    FOREIGN KEY (author_id) REFERENCES users(id)
 
);

INSERT INTO 
    questions(title, body, author_id)
VALUES
    ('How are you?', 'I would like to know how you are', (SELECT id from users WHERE fname = 'Jae' AND lname = 'Song'));
    -- ('How is the weather', 'what is the weather like', SELECT id from users WHERE fname = 'Andy' AND lname = 'Minucos');

CREATE TABLE question_follows(
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,
    
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
);
INSERT INTO
    question_follows(user_id, question_id)
VALUES
    ( (SELECT id from users WHERE fname = 'Jae' AND lname = 'Song'), (SELECT id from questions WHERE title = 'How are you?'));
    -- ( SELECT id from users WHERE fname = 'Andy' AND lname = 'Minucos', SELECT id from questions WHERE user_id = author_id);




CREATE TABLE replies(
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    parent_id INTEGER,
    author_id INTEGER NOT NULL,
    body TEXT NOT NULL,

    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (parent_id) REFERENCES replies(id),
    FOREIGN KEY (author_id) REFERENCES users(id)

);

INSERT INTO
    replies(question_id, parent_id, author_id, body)
 VALUES
    ((SELECT id FROM questions WHERE title = 'How are you?') , 
     (SELECT id FROM replies WHERE body = 'I would like to know how you are'),
     (SELECT id FROM users WHERE lname = 'Song' AND fname = 'Jae'), 
     'I would like to know how you are');

CREATE TABLE question_likes (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
    question_likes(user_id, question_id)
VALUES
    (
    (SELECT id FROM users WHERE lname = 'Song' AND fname = 'Jae'), 
    (SELECT id FROM questions WHERE title = 'How are you?') 
    );