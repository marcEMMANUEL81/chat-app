List getFullData() {
    dynamic discussions = [
      {
        "type": 'Discussion',
        "data": {
          "id_discussion": "9f32a5e1-c7d9-43c6-8bb0-972be71fb9f8",
          "id_user1": "b76c2e2d-9f9a-4fe7-a1e3-5908c0146ba7",
          "id_user2": "3f87d8ab-54e2-4d91-8206-6741a9ecfb4f",
        },
        "discussions": [],
        "user": []
      },
      {
        "type": 'Discussion',
        "data": {
          "id_discussion": "6b1a59cd-dbe0-45f2-a0c8-8129f4ec7635",
          "id_user1": "a26518e7-fac9-4b3d-910e-68bd2d75f6a1",
          "id_user2": "8c7abf9e-d041-4816-94e5-26d3e5c8a29d",
        },
        "discussions": [],
        "user": []
      },
    ];

    dynamic messages = [
      {
        "type": "Message",
        "data": {
          "id": 'b403a520-5e72-46ad-a113-5a347a578d51',
          "createdAt": 1699471295984,
          "text": 'Salut',
          "author": {"id": 'b76c2e2d-9f9a-4fe7-a1e3-5908c0146ba7'}
        },
        "receiver": "3f87d8ab-54e2-4d91-8206-6741a9ecfb4f",
        "id_discussion": "9f32a5e1-c7d9-43c6-8bb0-972be71fb9f8",
      },
      {
        "type": "Message",
        "data": {
          "id": 'b403a520-5e72-46ad-a113-5a347a578d52',
          "createdAt": 1699471295985,
          "text": 'Comment tu vas ?',
          "author": {"id": '3f87d8ab-54e2-4d91-8206-6741a9ecfb4f'}
        },
        "receiver": "b76c2e2d-9f9a-4fe7-a1e3-5908c0146ba7",
        "id_discussion": "9f32a5e1-c7d9-43c6-8bb0-972be71fb9f8",
      },
      {
        "type": "Message",
        "data": {
          "id": 'b403a520-5e72-46ad-a113-5a347a578d53',
          "createdAt": 1699471295986,
          "text": 'Salut',
          "author": {"id": 'a26518e7-fac9-4b3d-910e-68bd2d75f6a1'}
        },
        "receiver": "8c7abf9e-d041-4816-94e5-26d3e5c8a29d",
        "id_discussion": "6b1a59cd-dbe0-45f2-a0c8-8129f4ec7635",
      },
      {
        "type": "Message",
        "data": {
          "id": 'b403a520-5e72-46ad-a113-5a347a578d54',
          "createdAt": 1699471295987,
          "text": 'Comment tu vas ?',
          "author": {"id": '8c7abf9e-d041-4816-94e5-26d3e5c8a29d'}
        },
        "receiver": "a26518e7-fac9-4b3d-910e-68bd2d75f6a1",
        "id_discussion": "6b1a59cd-dbe0-45f2-a0c8-8129f4ec7635",
      },
    ];

    dynamic usersList = [
      {
        "name": "blé baka",
        "id_user": "3f87d8ab-54e2-4d91-8206-6741a9ecfb4f",
        "pic":
            'https://images.pexels.com/photos/4006576/pexels-photo-4006576.jpeg?auto=compress&cs=tinysrgb&w=800',
      },
      {
        "name": "BB kobs",
        "id_user": "a26518e7-fac9-4b3d-910e-68bd2d75f6a1",
        "pic":
            'https://images.pexels.com/photos/1181579/pexels-photo-1181579.jpeg?auto=compress&cs=tinysrgb&w=800',
      },
    ];

    List<Map<String, dynamic>> fullDiscussions = [];

    // Parcourez les discussions
    void function() {
      for (dynamic discuss in discussions) {
        for (dynamic message in messages) {
          if (discuss["data"]["id_discussion"] == message["id_discussion"]) {
            discuss["discussions"].add(message);
          }
        }
      }

      for (dynamic discuss in discussions) {
        for (dynamic user in usersList) {
          if (discuss["data"]["id_user1"] == user["id_user"] ||
              discuss["data"]["id_user2"] == user["id_user"]) {
            discuss["user"].add(user);
          }
        }
      }

    }

    function();
    return discussions;
  }