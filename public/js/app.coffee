
class Game
  constructor: () ->
    console.log "Initializing game..."
    @initScene()
    @initCamera()
    @initRenderer()
    @initEventHandlers()
    @eventState =
      UP: 0
      LEFT: 0
      DOWN: 0
      RIGHT: 0
      SPACEBAR: 0
      STRAFE_LEFT: 0
      STRAFE_RIGHT: 0

    @gameCounter = 1

    drawPlane(@scene)

    @player = new Player(0, 0, @scene)
    @monsters = []

    @render()

  initScene: () ->
    @scene = new THREE.Scene();
    @scene.add( new THREE.AmbientLight( 0x404040 ) );

  initCamera: () ->
    @camera = new THREE.PerspectiveCamera(45, window.innerWidth / window.innerHeight, 1, 1000);
    @camera.position.y = -450;
    @camera.position.z = 100;
    @camera.rotation.x = 45 * (Math.PI / 180);

  updateCamera: () ->
    DISTANCE_BEHIND = 200
    DISTANCE_ABOVE = 200
    rotZ = @player.cube.rotation.z
    x = @player.cube.position.x
    y = @player.cube.position.y

    @camera.rotation.z = 0
    @camera.position.x =  ((Math.sin -rotZ) * DISTANCE_BEHIND ) + x
    @camera.position.y =   ((Math.cos -rotZ) * DISTANCE_BEHIND ) + y

    @camera.up.set(0, 0, 1)
    @camera.lookAt(@player.cube.position)

  initRenderer: () ->
    @renderer = new THREE.WebGLRenderer();
    @renderer.setSize( window.innerWidth, window.innerHeight);
    document.body.appendChild( @renderer.domElement );

  initEventHandlers: () ->
    document.addEventListener("keydown", @keyboardEvent, false);
    document.addEventListener("keyup", @keyboardEvent, false);
    document.addEventListener("click", @mouseEvent, false)

  mouseEvent: (e) ->

  keyboardEvent: (e) =>
    keyValue = if e.type == "keydown" then 1 else 0
    switch e.keyCode
      when 81
        @eventState.STRAFE_LEFT = keyValue
      when 69
        @eventState.STRAFE_RIGHT = keyValue
      when 65, 37 
        @eventState.LEFT = keyValue
      when 87, 38
        @eventState.UP = keyValue
      when 68, 39
        @eventState.RIGHT = keyValue
      when 83, 40
        @eventState.DOWN = keyValue
      when 32
        @eventState.SPACEBAR = keyValue

  updateMonsters: () ->
    if @gameCounter % 180 == 0
      for i in [1..@gameCounter / 180]
        @monsters.push spawnMonster(@scene)

    for m in @monsters
      m.update(@player.cube.position.x, @player.cube.position.y)

    for m in @monsters 
      for b in @player.bullets
        bX = b.cube.position.x
        bY = b.cube.position.y
        mX = m.cube.position.x 
        mY = m.cube.position.y 

        if Math.sqrt( (bX - mX) ** 2 + (bY - mY) ** 2) < 10
          m.remove()
          b.remove()
          m.alive = false
          b.alive = false

    @player.bullets = @player.bullets.filter (b) -> b.alive
    @monsters = @monsters.filter (b) -> b.alive

  gameOverCheck: () ->
    for m in @monsters
      pX = @player.cube.position.x 
      pY = @player.cube.position.y
      mX = m.cube.position.x 
      mY = m.cube.position.y

      if Math.sqrt( (pX - mX) ** 2 + (pY - mY) ** 2) < 10
        console.log "GAME OVER"
        @gameOver()

  render: () =>
    @gameCounter += 1
    requestAnimationFrame(@render);

    @gameOverCheck()
    @player.update(@eventState)
    @updateCamera()
    @updateMonsters()

    @renderer.render(@scene, @camera);

  gameOver: () ->
    for m in @monsters
      m.remove()

    for b in @player.bullets
      b.remove()

    @player.remove()
    
    @gameCounter = 1
    @player = new Player(0, 0, @scene)
    @monsters = []

spawnMonster = (scene) ->
  switch Math.floor((Math.random()*4)+1)
    when 1
      x = Math.floor((Math.random() * MAP_LENGTH) - MAP_LENGTH/2)
      y = MAP_LENGTH/2
    when 2
      y = Math.floor((Math.random() * MAP_LENGTH) - MAP_LENGTH/2)
      x = MAP_LENGTH/2
    when 3
      x = Math.floor((Math.random() * MAP_LENGTH) - MAP_LENGTH/2)
      y = -MAP_LENGTH/2
    when 4
      y = Math.floor((Math.random() * MAP_LENGTH) - MAP_LENGTH/2)
      x = -MAP_LENGTH/2

  m = new Monster(x, y, scene)
  m

addCube = (x, y, z, color, scene) ->
  geometry = new THREE.CubeGeometry(10, 10, 10)
  material = new THREE.MeshBasicMaterial {color}
  cube = new THREE.Mesh(geometry, material);
  scene.add(cube)

  cube

drawPlane = (scene) ->
  window.MAP_LENGTH = 500
  plane = new THREE.Mesh(new THREE.PlaneGeometry(500, 500), new THREE.MeshNormalMaterial());
  plane.overdraw = true;
  scene.add(plane);


g = new Game()
window.g = g