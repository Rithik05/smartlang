describe("Login Page Test", () => {
    it('authorized user should be able to navigate to other pages upon a Successful Login', () => {
        cy.mockLoginAuthorizedUser()
        cy.visit('/home')
        cy.url().should('eq', 'http://localhost:4000/home')
    })

    it('unauthorized user should be redirected to login page', () => {
        cy.mockLoginUnauthorizedUser()
        cy.visit('/home')
        cy.url().should('eq', 'http://localhost:4000/') // Unauthorized would be redirected to Login page
    })
})