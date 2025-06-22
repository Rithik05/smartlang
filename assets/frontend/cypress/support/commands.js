// ***********************************************
// This example commands.js shows you how to
// create various custom commands and overwrite
// existing commands.
//
// For more comprehensive examples of custom
// commands please read more here:
// https://on.cypress.io/custom-commands
// ***********************************************
//
//
// -- This is a parent command --
// Cypress.Commands.add('login', (email, password) => { ... })
//
//
// -- This is a child command --
// Cypress.Commands.add('drag', { prevSubject: 'element'}, (subject, options) => { ... })
//
//
// -- This is a dual command --
// Cypress.Commands.add('dismiss', { prevSubject: 'optional'}, (subject, options) => { ... })
//
//
// -- This will overwrite an existing command --
// Cypress.Commands.overwrite('visit', (originalFn, url, options) => { ... })

Cypress.Commands.add('mockLoginAuthorizedUser', () => {
    mockLogin('valid_user@smartlang.com')
})

Cypress.Commands.add('mockLoginUnauthorizedUser', () => {
    mockLogin('invalid_user@smartlang.com')
})

Cypress.Commands.add('mockSummarizeApi', () => {
    cy.intercept('POST', '/summarizer/summarize', {
        statusCode: 200,
        body: {
            response: [{ text: 'This is a mock summary.' }]
        }
    }).as('summariseRequest')
})

Cypress.Commands.add('mockSupportedLanguagesApi', () => {
    const languages = [
        { languageCode: "en", displayName: "English" },
        { languageCode: "fr", displayName: "French" },
        { languageCode: "ru", displayName: "Russian" }
    ]
    cy.intercept('GET', '/translator/supported_languages', {
        statusCode: 200,
        body: {
            response: { languages: languages }
        }
    }).as('supportedLanguages')
    cy.wait('@supportedLanguages')
})

Cypress.Commands.add('mockTranslateApi', () => {
    cy.intercept('POST', '/translator/translate', (req) => {
        console.log(req.body, "req body bro")
        expect(req.body.source).to.equal('en')
        expect(req.body.target).to.equal('fr')

        req.reply({
            statusCode: 200,
            body: {
                response: { translations: [{ translatedText: 'Bonjour' }] }
            }
        })
    }).as('translateText')

})

const mockLogin = (email) => {
    // Visit the login page if your flow requires it
    cy.visit('/')

    // Check that the login link exists
    cy.get('button')
        .then(() => {
            // Hit the /auth/google route and expect a 302 redirect
            cy.request({
                url: '/auth/google',
                followRedirect: false,
            }).then((resp) => {
                expect(resp.status).to.eq(302)
            })
        })

    // Request the test callback endpoint to mock authentication
    // cy.request(`GET`, `/cypress/auth/google/callback?email=${email}`)
    cy.request({
        url: `/cypress/auth/google/callback?email=${email}`,
        failOnStatusCode: false
    })
}
