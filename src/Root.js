import React from 'react'
import {BrowserRouter, Route, Switch} from  'react-router-dom'
import App from './App'
import Login from './components/OAuth/login'
import Raffle from './components/Raffle/Raffle'

const Root = () => {

  const [token, setToken] = React.useState('')

  return (
    <BrowserRouter basename={process.env.PUBLIC_URL}>
      <Switch>
        <Route  exact path="/" 
                render={(props) => <App {...props}/>}/>
        {/* Heroku Access Token 관련 보안 문제 이슈로 인해 주석 처리 */}
        {/*<Route  path="/login/:category" */}
        {/*        render={(props) => <Login setToken={setToken} {...props}/>}/>*/}
        <Route  path="/raffle/:category"
                render={(props) => <Raffle token={token} {...props}/>}/>
      </Switch>
    </BrowserRouter>
  )
}

export default Root
