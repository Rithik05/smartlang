describe("Translator Page", () => {
    it('should show dropdown of supported languages and be able to translate the text', () => {
        const text = 'Hello';
        cy.mockLoginAuthorizedUser()
        cy.visit('/translator')
        cy.mockSupportedLanguagesApi()
        cy.get("#sourceLanguage").find('button').click({ force: true })
        cy.contains('English').click({ force: true })
        cy.get("#targetLanguage").find('button').contains('Choose Language').click({ force: true })
        cy.contains('French').click({ force: true })
        cy.mockTranslateApi()
        cy.get('textarea[placeholder="Start Typing..."]').type(text)
            .should('have.value', text)

        cy.wait('@translateText')
        cy.get("#targetLanguage").contains('Bonjour')
    })
})