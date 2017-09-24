<score>

  <div class="active-player-list">
    <div class="card active-player" each={ activePlayers }>
      <header class="card-header">
        <div class="card-header-title columns is-mobile">
          <div class="column is-9">
            { this.name }
          </div>
          <div class="column is-3 is-pulled-right">
            <span class="tag is-primary is-medium">{ this.score }</span>
          </div>
        </div>
      </header>
      <div class="card-content" if={ this.manualScore }>
        <form onsubmit="{ registerPlayer }">
          <div class="field has-addons">
            <div class="control is-expanded">
              <input class="input is-primary" type="number" ref="manualScore" placeholder="Nouveau score" value={ this.score }>
              </div>
              <div class="control">
                <button class="button is-primary" onclick={ setScoreManually }>
                  OK
                </button>
              </div>
            </div>
          </form>
        </div>
        <footer class="card-footer">
          <a href="#" class="card-footer-item" onclick={ parent.addOne }>+1</a>
          <a href="#" class="card-footer-item" onclick={ parent.addFive }>+5</a>
          <a href="#" class="card-footer-item" onclick={ parent.toggleManualScore }>Edit</a>
          <a href="#" class="card-footer-item is-danger" onclick={ parent.reset }>Reset</a>
        </footer>
      </div>
  </div>

  <div class="box" if={ activePlayers.length > 1 }>
    <a href="#" onclick="{ sortByHigherScoreFirst }">Trier par score décroissant</a>
  </div>
  
  <div class="box">
    <div class="columns">
      <div class="column">
        <form onsubmit="{ registerPlayer }">
          <div class="field has-addons">
            <div class="control is-expanded">
              <input id="register-player" class="input" ref="name" type="text" placeholder="Nom du joueur" autofocus autocomplete="off">
            </div>
            <div class="control">
              <button type="submit" class="button is-primary">
                Ajouter
              </button>
            </div>
          </div>
        </form>
      </div>
    </div>
    
    <div class="message is-danger" if={ error }>
      <div class="columns">
        <div class="column">
          <div class="message-header">
            Erreur
          </div>
          <div class="message-body">
            { error.message }
          </div>
        </div>
      </div>
    </div>
    
    <div id="player-history" class="field is-grouped is-grouped-multiline" if={ playersHistory.length }>
      <span class="control">
        <button class="button is-danger is-outlined" onclick="{ clearHistory }">
          Supprimer historique
        </button>
      </span>
      <span class="control" each={ playerName in playersHistory }>
        <button class="button is-primary is-outlined" onclick="{ registerPlayerFromHistory }">
          { playerName }
        </button>
      </span>
    </div>
  </div>
  
  <script>
    this.activePlayers = []
    this.playersHistory = JSON.parse(window.localStorage.getItem("players-history") || "[]")
    this.error = null
    
    registerPlayer(e) {
      e.preventDefault()
      
      const playerName = this.refs.name.value
      const isValid = _validatePlayerName.call(this, playerName)
      if (!isValid) {
        return
      }
      
      this.error = null;
      this.refs.name.value = ""
      this.activePlayers.push({name: playerName, score: 0})
      document.getElementById("register-player").focus()
      
      _savePlayerName.call(this, playerName)
    }
    
    function _savePlayerName(newPlayerNameToAdd) {
      const storedPlayersHistory = JSON.parse(window.localStorage.getItem("players-history") || "[]")
      
      const playerNameAlreadyExists = storedPlayersHistory.some(nameInList => nameInList.toLowerCase() === newPlayerNameToAdd.toLowerCase())
      if (playerNameAlreadyExists) {
        return
      }

      this.playersHistory.push(newPlayerNameToAdd)
      window.localStorage.setItem("players-history", JSON.stringify(this.playersHistory))
    }
    
    registerPlayerFromHistory(e) {
      e.preventDefault()
      
      const playerName = e.item.playerName
      const isValid = _validatePlayerName.call(this, playerName)
      if (!isValid) {
        return
      }
      
      this.error = null;
      this.refs.name.value = ""
      
      this.activePlayers.push({name: playerName, score: 0})

      document.getElementById("register-player").focus()
    }
    
    function _validatePlayerName(playerName) {
      if (!playerName) {
        this.error = { message: "Le nom du joueur ne peut être vide." }
        return false
      }
      
      if (playerName.length < 3) {
        this.error = { message: "Le nom du joueur doit faire au moins 3 caractères." }
        return false
      }
      
      const playerAlreadyInGame = this.activePlayers.some(player => player.name.toLowerCase() === playerName.toLowerCase())
      if (playerAlreadyInGame) {
        this.error = { message: "Ce nom de joueur est déjà pris." }
        return false
      }

      return true
    }
    
    clearHistory(e) {
      e.preventDefault()
      this.playersHistory = []
      window.localStorage.setItem("players-history", "[]")
      this.error = ""
    }
    
    addOne(e) {
      e.preventDefault()
      e.item.score += 1
    }
    
    addFive(e) {
      e.preventDefault()
      e.item.score += 5
    }
    
    reset(e) {
      e.preventDefault()
      e.item.score = 0;
    }
    
    setScoreManually(e) {
      e.preventDefault()
      e.item.score = parseInt(this.refs.manualScore.value, 10)
      e.item.manualScore = false
    }
    
    toggleManualScore(e) {
      e.preventDefault()
      e.item.manualScore = !e.item.manualScore
    }
    
    sortByHigherScoreFirst(e) {
      e.preventDefault()
      this.activePlayers = this.activePlayers.sort((playerA, playerB) => playerB.score - playerA.score);
    }

  </script>
</score>
