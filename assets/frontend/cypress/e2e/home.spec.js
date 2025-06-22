describe("Home Page Test", () => {
    beforeEach(() => {
        cy.mockLoginAuthorizedUser()
        cy.visit("/home") // only an authorized user would be able to navigate to home page
    })

    it("should display the app header", () => {
        cy.get('header').contains('Smartlang-AI').should('be.visible')
        cy.get('header button').should('exist').click()
        cy.get('header').within(() => {
            cy.contains("valid_user@smartlang.com").should('be.visible')
            cy.contains('Sign out').should('be.visible').click({ force: true })
        })
        cy.url().should('eq', 'http://localhost:4000/')
    })

    it("should display Summarizer button and onclick should navigate to that page", () => {
        cy.contains('Summarizer').should('be.visible').click()

        cy.url().should('include', '/summarizer')

    })

    it("should display Translator button and onclick should navigate to that page", () => {
        cy.contains('Translator').should('be.visible').click()

        cy.url().should('include', '/translator')

    })
})