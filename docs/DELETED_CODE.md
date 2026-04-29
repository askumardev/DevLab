<ul>
  <li>The app is configured to run with <code>docker-compose</code>. See <code>README.md</code> for commands.</li>
  <li>Start the stack with: <code>docker-compose up -d --build</code></li>
  <li>Visit <code>/articles</code> to see the Article index table.</li>
</ul>
-------------------------

<li><%= link_to 'Create New Article', new_article_path %></li>
<li><%= link_to 'Seed the database (docker-compose)', '#', onclick: "alert('Run `docker-compose run --rm seed` in your terminal to seed the DB')" %></li>
<li><%= link_to 'README', '/README.md' %></li>
