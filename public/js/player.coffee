PLAYER_MOVE_SPEED = 2
COLORS = [0xFF0000, 0xFF7F00, 0xFFFF00, 0x00FF00, 0x0000FF, 0x4B0082, 0x8F00FF]
MAX_BULLETS = 30

class Player
  constructor: (@X, @Y, @scene) ->
    console.log "Player created at #{@X}, #{Y}"

    @geometry = new THREE.CubeGeometry(10, 10, 10)
    @material = new THREE.MeshBasicMaterial {color: 0x00FF00 }
    @cube = new THREE.Mesh(@geometry, @material);
    @cube.position.z = 5
    @scene.add(@cube)
    @bullets = []
    @colorIndex = 0
    @alive = true

  generateColor: () ->
    frequency = .3;
    i = @colorIndex 
    @colorIndex = (@colorIndex + 1) % 32

    red   = Math.floor(Math.sin(frequency*i + 0) * 127 + 128)
    green = Math.floor(Math.sin(frequency*i + 2) * 127 + 128)
    blue  = Math.floor(Math.sin(frequency*i + 4) * 127 + 128)
    return "rgb(#{red},#{green},#{blue})"

  update: (eventState) ->
    if eventState.RIGHT
      @cube.rotation.z -= .1
    if eventState.LEFT
      @cube.rotation.z += .1
    if eventState.UP
      @cube.position.x -= (Math.sin (-1 * @cube.rotation.z)) * 4
      @cube.position.y -= (Math.cos (- 1 *@cube.rotation.z)) * 4
    if eventState.DOWN
      @cube.position.x += (Math.sin (-1 * @cube.rotation.z)) * 4
      @cube.position.y += (Math.cos (- 1 *@cube.rotation.z)) * 4
    if eventState.STRAFE_LEFT
      @cube.position.x -= (Math.sin (-1 * @cube.rotation.z - Math.PI/2)) * 4
      @cube.position.y -= (Math.cos (- 1 *@cube.rotation.z - Math.PI/2)) * 4
    if eventState.STRAFE_RIGHT
      @cube.position.x -= (Math.sin (-1 * @cube.rotation.z + Math.PI/2)) * 4
      @cube.position.y -= (Math.cos (- 1 *@cube.rotation.z + Math.PI/2)) * 4
    if eventState.SPACEBAR
      if @bullets.length <= MAX_BULLETS
        b = new Bullet @cube.position.x, @cube.position.y, @cube.rotation.z, @scene, @generateColor()
        @bullets.push(b)

    badBullets = @bullets.filter (b) -> !b.boundsCheck()
    for bad in badBullets
      bad.remove()

    @bullets = @bullets.filter (b) -> b.boundsCheck()
    for b in @bullets
      b.move()

  remove: () ->
    @scene.remove(@cube)

window.Player = Player
