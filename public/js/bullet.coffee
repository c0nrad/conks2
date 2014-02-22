class Bullet
  constructor: (@X, @Y, @direction, @scene, @color ) ->

    @geometry = new THREE.CubeGeometry(1, 1, 1)
    @material = new THREE.MeshBasicMaterial {color: @color }
    @cube = new THREE.Mesh(@geometry, @material);
    @cube.position.z = 5
    @cube.position.x = @X
    @cube.position.y = @Y
    @alive = true
    @scene.add(@cube)

  remove: () ->
    @scene.remove(@cube)

  move: () ->
    @cube.position.x -= 5 * Math.cos (@direction + Math.PI/2)
    @cube.position.y -= 5 * Math.sin (@direction + Math.PI/2)   

  boundsCheck: () ->
    radi = window.MAP_LENGTH / 2
    if @cube.position.x > radi or @cube.position.x < -radi
      return false
    if @cube.position.y > radi or @cube.position.y < -radi
      return false

    return true
window.Bullet = Bullet

