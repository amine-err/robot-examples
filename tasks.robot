*** Settings ***
Documentation       Test robot framework with jsonplaceholder api

Library             RequestsLibrary
Library             Collections
Library             JSONLibrary
Library             OperatingSystem
Library             fixtures/userCreation.py


*** Variables ***
${baseUrl}      https://jsonplaceholder.typicode.com


*** Tasks ***
Get user by username
    [Tags]    get

    # Get users
    Create Session    mysession    ${baseUrl}    verify=true
    ${response}    GET On Session    mysession    /users
    Status Should Be    200    ${response}

    # Get user id by username
    FOR    ${user}    IN    @{response.json()}
        ${username}    Get Value From Json    ${user}    username
        ${userId}    Get Value From Json    ${user}    id
        IF    "${username}[0]" == "Maxime_Nienow"    BREAK
    END
    ${userId}    Get From List    ${userId}    0
    Log    "userId : ${userId}"
    Set Global Variable    ${userId}

Change user email
    [Tags]    patch

    # change user email
    Create Session    mysession    ${baseUrl}    verify=true
    &{body}    Create Dictionary    email=Sherwood@gmail.com
    ${response}    PATCH On Session    mysession    /users/${userId}    json=${body}
    Status Should Be    200    ${response}

    # Check email is modified
    ${userEmail}    Get Value From Json    ${response.json()}    email
    ${userEmail}    Get From List    ${userEmail}    0
    Should be equal As Strings    "${userEmail}"    "Sherwood@gmail.com"

Create a post for user
    [Tags]    post

    # create post
    Create Session    mysession    ${baseUrl}    verify=true
    &{body}    Create Dictionary    title="post title"    body="post body"
    ${response}    POST On Session    mysession    /users/${userId}/posts    json=${body}
    Status Should Be    201    ${response}

    # Check post is created
    ${postUserId}    Get Value From Json    ${response.json()}    userId
    ${stringUserId}    Convert To String    ${userId}
    Should Be Equal As Strings    ${postUserId}[0]    ${stringUserId}

    ${postTitle}    Get Value From Json    ${response.json()}    title
    ${postTitle}    Get From List    ${postTitle}    0
    Should be equal As Strings    ${postTitle}    "post title"

Get post of user by title
    [Tags]    get

    # get user posts
    Create Session    mysession    ${baseUrl}    verify=true
    ${response}    GET On Session    mysession    /users/${userId}/posts
    Status Should Be    200    ${response}

    # Get post id by title
    FOR    ${post}    IN    @{response.json()}
        ${title}    Get Value From Json    ${post}    title
        ${postId}    Get Value From Json    ${post}    id
        IF    "${title}[0]" == "dignissimos eum dolor ut enim et delectus in"
            BREAK
        END
    END
    ${postId}    Get From List    ${postId}    0
    Log    "postId : ${postId}"
    Set Global Variable    ${postId}

Get post comment by email then delete it
    [Tags]    get    delete

    # get post comments
    Create Session    mysession    ${baseUrl}    verify=true
    ${response}    GET On Session    mysession    /posts/${postId}/comments
    Status Should Be    200    ${response}

    # Get post comment id by email
    FOR    ${comment}    IN    @{response.json()}
        ${email}    Get Value From Json    ${comment}    email
        ${commentId}    Get Value From Json    ${comment}    id
        IF    "${email}[0]" == "Lacey@novella.biz"    BREAK
    END
    ${commentId}    Get From List    ${commentId}    0
    Log    "commentId : ${commentId}"

    # Delete comment by id
    ${response}    DELETE On Session    mysession    /comments/${commentId}
    Status Should Be    200    ${response}

Get another comment and modify all its data
    [Tags]    get    put

    # get post comments
    Create Session    mysession    ${baseUrl}    verify=true
    ${response}    GET On Session    mysession    /posts/${postId}/comments
    Status Should Be    200    ${response}

    # Get post comment id by email
    FOR    ${comment}    IN    @{response.json()}
        ${email}    Get Value From Json    ${comment}    email
        ${commentId}    Get Value From Json    ${comment}    id
        IF    "${email}[0]" == "Lindsay@kiley.name"    BREAK
    END
    ${commentId}    Get From List    ${commentId}    0
    Log    "commentId : ${commentId}"

    # Put comment by id
    &{body}    Create Dictionary    name="comment name"    email="Lindsay@gmail.com"    body="comment body"
    ${response}    PUT On Session    mysession    /comments/${commentId}    json=${body}
    Status Should Be    200    ${response}

Create post from json file
    [Tags]    post    file

    # get data from json file
    ${jsonObject}    Evaluate    json.load(open("fixtures/post-creation.json", "r"))    json

    # create post
    Create Session    mysession    ${baseUrl}    verify=true
    ${response}    POST On Session    mysession    /posts    json=${jsonObject}
    Status Should Be    201    ${response}

    # Check post is created
    ${postTitle}    Get Value From Json    ${response.json()}    title
    ${postTitle}    Get From List    ${postTitle}    0
    Should be equal As Strings    ${postTitle}    ${jsonObject}[title]

Create multiple posts from data file
    [Tags]    post    file

    # get data from json file
    ${jsonObject}    Evaluate    json.load(open("fixtures/post-partie.json", "r"))    json

    FOR    ${jsonPost}    IN    @{jsonObject}
        # create post
        Create Session    mysession    ${baseUrl}    verify=true
        ${response}    POST On Session    mysession    /posts    json=${jsonPost}
        Status Should Be    201    ${response}

        # Check post is created
        ${postTitle}    Get Value From Json    ${response.json()}    title
        ${postTitle}    Get From List    ${postTitle}    0
        Should be equal As Strings    ${postTitle}    ${jsonPost}[title]
    END

Create user using faker library
    [Tags]    post    faker

    # create post
    Create Session    mysession    ${baseUrl}    verify=true
    &{body}    User Creation Payload
    ${response}    POST On Session    mysession    /users    json=${body}
    Status Should Be    201    ${response}

    # Check post is created
    ${name}    Get Value From Json    ${response.json()}    name
    ${name}    Get From List    ${name}    0
    Should be equal As Strings    ${name}    ${body}[name]
